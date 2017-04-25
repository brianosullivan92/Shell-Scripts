#!/bin/bash
#The MIT License
#
#Copyright (c) 2007 Cappy

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#---
#Author: Cappy of ubuntuforums.org
#Website: http://ubuntuforums.org/showthread.php?t=474790
#Version: 2.06 / 2.07
#Purpose: Download and install native and non-native libraries
#---
#
# GetLIBs.txt:
#
# getlibs works on:
#    * All Ubuntu and Debian systems
#    * Debian or Ubuntu based distributions (best to use the package name)
#
# Tip: To install a 32-bit debian package for a program (not a library!) use:
#   sudo dpkg -i --force-all package_name.deb
#
# Usage Examples:
#
# getlibs on a program to download all missing libraries:
#   getlibs /usr/bin/skype
#
# Use getlibs to install a 32-bit library using the library name:
#   getlibs -l libogg.so.0 libSDL-1.2.so.0
#
# Use getlibs to install a 32-bit library using the package name:
#   getlibs -p libqt4-core libqt4-gui
#
# Install a 32-bit library file (.deb):
#   getlibs -i ~/i386_library_1.deb
#
# Download and install a 32-bit library file (.deb):
#   getlibs -w http://mirrors.kernel.org/ubuntu/pool/main/s/sdl-image1.2/libsdl-image1.2_1.2.5-3_i386.deb
#
# Other options:
#
# --apt-file :
#   Uses apt-file to find the packagenames for libraries.
#   The default uses packages.ubuntu.com.
#   This is especially useful for non-ubuntu users.
#
# --build :
#   Converts a 32-bit package to a 64-bit package and installs it.
#   This will only install libraries from a 32-bit package into the correct place!
#   This will not install any binaries from that package! This is very beta.
#
# --savebuild :
#   Use with --build. Saves new 64-bit package to /home/$USER
#
# --mirror or -m :
#   Use the specified mirror to download from if one is not specified for package
#
# --verbose :
#   Extra output
#
# --ldconfig :
#   Runs ldconfig on directories where new libraries are installed
#
# -64 :
#   Will let apt-get install 64-bit packages for a 64-bit system
#
# -32 :
#   Left only for compatibility with getlibs v1.
#   32-bit library installation is the default for all systems.
#
# --distro :
#   Can set as either Ubuntu or Debian.
#   Ubuntu installs to /usr/lib32 and/or /lib32.
#   Debian installs to /emul/ia32-linux/
#
# --release :
#   Can set as hardy gutsy, feisty, edgy, dapper, etc.
#   Determines what web interface release is used in search.
#
##############################################################################

print_usage() {
    echo "\
Usage: getlibs /path/to/binary
       getlibs -l i386librarytoinstall.so
       getlibs -p i386packagename
       getlibs -w www.website.com/i386package.deb
       getlibs -i /home/$USER/i386package.deb
       See 'man getlibs', or getlibs.txt, for more options"
    clean_up_err
}

clean_up() {
    rm -rf $tempdir # Normal exit without errors (via TRAP)
}

clean_up_err() {
    rm -rf $tempdir
    exit 1
}

wget_fail() {
    echo "\
The mirrors do not have the requested file or there is no internet connection"
    #clean_up_err
}

not_an_executable() {
    echo "\
Cannot determine the dependencies required by this program, it may be a script:
If this program needs a 32-bit library use:
  getlibs -l i386librarytoinstall.so
If this program needs a 64-bit library use:
  getlibs -64l amd64librarytoinstall.so"
    clean_up_err
}

stored_list() {
    stored="
libXss.so.1 libxss1
libdbus-1.so.2 libdbus-1.so.3 libdbus-1-3
libQtCore.so.4 libQtNetwork.so.4 libQtDBus.so.4 libqt4-core
libQtGui.so.4 libqt4-gui
libsigc-2.0.so.0 libsigc++-2.0-0c2a
libasound_module_pcm_pulse.so libasound2-plugins
libglitz-glx.so.1 libglitz-glx1
libglitz.so.1 libglitz1
librsvg-2.so.2 librsvg2-2
libcroco-0.6.so.3 libcroco3
libgsf-1.so.114 libgsf-1-114
libqt-mt.so.3 libqt3-mt
libgtk-1.2.so.0 libgtk1.2
libgmodule-1.2.so.0 libglib1.2
libSDL-1.2.so.0 libsdl1.2debian-all
libXxf86vm.so.1 libxxf86vm1
libXxf86dga.so.1 libxxf86dga1
libcurl.so.3 libcurl3
"

    found=`echo "$stored" | grep -m 1 "$1" | grep -o "[^ ]*$"`
    if [ -n "$found" ]; then
        echo "$found"
    fi
}

use_web_interface() {
    PACKAGE=`echo $1 | sed s/\+/%2B/g`
    if [ "$distro" = "Ubuntu" ]; then
        searchaddress="http://packages.ubuntu.com/search?searchon=contents&keywords=$PACKAGE&mode=exactfilename&suite=$release&arch=i386"
    else
        searchaddress="http://packages.ubuntu.com/search?searchon=contents&keywords=$PACKAGE&mode=exactfilename&suite=gutsy&arch=i386"
    fi
    packagenames=`wget --user-agent="getlibs" -q -O- "$searchaddress"`
    if [ -z "$packagenames" ]; then
        echo 'Not able to connect to http://packages.ubuntu.com to find the package name'
    fi
    packagenames=`echo "$packagenames" | sed -n '/<td class=\"file\">/,/<\/td>/p' | grep -v '"keyword"' | grep -v "\(/debug/\|-dbg\)" | sed 's/<[^>]*>,*//g' | grep -m1 '[[:alnum:]]' | sed 's/[[:space:]]//g'`
    if [ -n "$packagenames" ]; then
        echo "$packagenames"
    fi
}

apt_file() {
    returned=`apt-file search $1 | grep -m 1 -v "\(debug\|dbg\)" | cut -f1 -d ' '`
    if [ -n "$returned" ]; then
        echo ${returned/:/}
    fi
}

# Attempts to link libGL.so.1 to a driver if libGL.so.1 does not exist

video_drivers() {
    if [ "$installtype" = "native" ]; then
        videopath="/usr/lib"
    else
        videopath="/usr/lib32"
    fi

    if [ -z "`ls $videopath/libGL.so.* 2> /dev/null`" ]; then
        echo "libGL is installed from video drivers, please install or reinstall your video drivers"
    elif [ -f "$videopath/libGL.so.1" ]; then
        echo "libGL is installed from video drivers, please install or reinstall your video drivers"
    else
        videodriver=`ls $videopath/libGL.so.* | grep -o -m 1 '[^ ]*'`
        ln -s "$videodriver" "$videopath/libGL.so.1"
        echo "Created symbolic link from $videodriver to $videopath/libGL.so.1"
    fi
}

copy_fail() {
    echo "Copying files failed - run getlibs with \"sudo getlibs\" or as root"
    clean_up_err
}

dpkg_repack() {
    eachdeb="$1"

    debdir="`echo $eachdeb | sed 's/.deb//'`"
    debbase=`basename $debdir`

    dpkg --extract "$eachdeb" "$debdir-tmp"
    dpkg --control "$eachdeb" "$debdir-tmp/DEBIAN"
    mkdir -p "$debdir/DEBIAN"
    cd "$debdir-tmp"

    if [ -d "$debdir-tmp/lib" ]; then
        mv "lib" "lib32"
        cp -R "lib32/" "$debdir"
    fi

    if [ -d "$debdir-tmp/usr/lib" ]; then
        mkdir -p "$debdir/usr/"
        mv "usr/lib" "usr/lib32"
        cp -R "usr/lib32/" "$debdir/usr"
    fi
    
    if [ -f "DEBIAN/md5sums" ]; then
        grep ' \(usr/lib/\|lib/\)' DEBIAN/md5sums | sed 's+ lib/+ lib32/+g' | sed 's+ usr/lib/+ usr/lib32/+g' > "$debdir/DEBIAN/md5sums"
    fi

    debarch=`grep 'Architecture:' DEBIAN/control`
    debpackage=`grep 'Package:' DEBIAN/control`
    if [ -n "`echo $debpackage | grep lib`" ]; then
        newdebpackage=`echo ${debpackage/lib/lib32}`
    else
        newdebpackage="$debpackage-i386"
    fi
    sed "s/$debarch/Architecture: all/g" DEBIAN/control | sed "s/$debpackage/$newdebpackage/" | grep -v 'Depends:' | grep -v 'Conflicts:' | grep -v 'Replaces:' > "$debdir/DEBIAN/control"

    if [ -f "DEBIAN/postinst" ]; then
        cp "DEBIAN/postinst" "$debdir/DEBIAN"
    fi
    if [ -f "DEBIAN/postrm" ]; then
        cp "DEBIAN/postrm" "$debdir/DEBIAN"
    fi

    cd "$tempdir/build"
    dpkg --build "$debdir" "$debbase.deb"
    echo "Installing new $newdebpackage"
    sudo dpkg -i "$debbase.deb"
    if [ -n "$savebuild" ]; then
         echo "Moving new package $debbase.deb to /home/$USER/"
         cp $debbase.deb "/home/$USER/"
    fi
}

##############################################################################
##############################################################################

# Trap all main exits, and run these procs

trap clean_up_err 1 2 3 13 15   #Script error or interrupt
trap clean_up 0                 #Normal exit

PATH="/usr/bin:/bin:/sbin:/usr/sbin:$PATH"; export PATH


version="Getlibs version 2.07 - March 1st 2008 + Ubuntu mods, and MJK mods (Feb, 2011)."    #<<<<<<<<<<<<<<<<<<<<<<<<<


# Set 64-bit machines to download 32-bit if no options are set

architecture=`uname -m`
targetarch="x86"
if [ "$architecture" != "x86_64" ] && [ "$architecture" != "ia64" ]; then
    architecture="x86"
else
    architecture="x86_64"
fi

tempdir=`mktemp -d /tmp/getlibs.XXXXXXXXXX`
if [ $? -ne 0 ]; then
    echo "Unable to create temp directory in /tmp"
    clean_up_err
fi

shopt -s xpg_echo

# Get distro and release

distro=`lsb_release -i | cut -f2`
if [ "$distro" = "Ubuntu" ]; then
    release=`lsb_release -c | cut -f2` #dapper, edgy, gutsy, etc.
else
    if [ "$architecture" = "x86_64" ]; then
        if [ -d /emul/ia32-linux ]; then
            distro="Debian"
        else
            distro="Ubuntu"; release="gutsy";
        fi
    else
        distro="Debian"
    fi
fi

# If 64-bit ubuntu and ia32-libs is not installed

if [ "$architecture" = "x86_64" ] && [ "$distro" = "Ubuntu" ] && [ ! -e "/usr/lib32/libGLU.so.1" ]; then
    sudo apt-get install ia32-libs
elif [ "$architecture" = "x86_64" ] && [ "$distro" = "Debian" ] && [ ! -d "/emul/ia32-linux" ]; then
    sudo apt-get install ia32-libs
fi

if [ $# -lt 1 ]; then
    print_usage
fi

set -- `getopt -u -a --longoptions="32: 64: binary: library: package: distro: release: file: link: mirror: ldconfig remove: help update version yes verbose apt-file extract build savebuild" "b: l: p: d: r: i: w: m: c r: u v h" "$@"`

while [ $# -gt 0 ]; do
    case "$1" in
        --32)        targetarch="x86";;
        --64)        targetarch="x86_64";;
        --binary)    binarypath="$2"; shift;;
        -b)          binarypath="$2"; shift;;
        --library)   library="true"; parameters="$parameters $2"; shift;;
        -l)          library="true"; parameters="$parameters $2"; shift;;
        --package)   package="true"; parameters="$parameters $2"; shift;;
        -p)          package="true"; parameters="$parameters $2"; shift;;
        --distro)    distro="$2"; shift;;
        -d)          distro="$2"; shift;;
        --release)   release="$2"; shift;;
        -r)          release="$2"; shift;;
        --file)      file="true"; parameters="$parameters $2"; shift;;
        -i)          file="true"; parameters="$parameters $2"; shift;;
        --link)      download="true"; parameters="$parameters $2"; shift;;
        -w)          download="true"; parameters="$parameters $2"; shift;;
        --mirror)    mirror2="$2"; parameters="$parameters $2"; shift;;
        -m)          mirror2="$2"; parameters="$parameters $2"; shift;;
        --ldconfig)  ldconfig="true";;
        -c)          ldconfig="true";;
        --remove)    remove="true"; parameters="$parameters $2"; shift;;
        -r)          remove="true"; parameters="$parameters $2"; shift;;
        --update)    update="true";;
        -u)          update="true";;
        --version)   echo "$version";;
        -v)          echo "$version";;
        --yes)       prompt="yes";;
        --verbose)   verbose="true";;
        --apt-file)  aptfile="true";;
        --extract)   extract="true";;
        --build)     build="true";;
        --savebuild) savebuild="true";;
        --help)      print_usage;;
        -h)          print_usage;;
        --)          shift; break;;
        -*)          print_usage; exit 1;;
        *)           break;;
    esac
    shift
done

# If no parameters, decide if it is a binary or a library

if [ -n "$1" ] && [ -z "$library" ] && [ -z "$binarypath" ] && [ -z "$download" ] && [ -z "$package" ] && [ -z "$file" ]; then
    if [ -n "`echo "$1" | grep "\.so"`" ]; then
        library="true";
    else
        #if [ -f "$1" ]; then
            binarypath="$1"
        #else
            #echo "$1 is not an existing file. Assuming this is a package name.\n"
            #package="true"
        #fi
    fi
fi

while [ $# -gt 0 ]; do
    if [ "$1" != "--" ]; then
        parameters="$parameters $1"
    fi
    shift
done

# Find missing dependencies for a binary

if [ -n "$binarypath" ]; then
    if [ ! -f "$binarypath" ]; then
        echo "The file \"$binarypath\" does not exist"
        print_usage
    elif [ ! -r "$binarypath" ]; then
        echo "The file \"$binarypath\" does not have read permissions"
        clean_up_err
    elif [ -z "`file "$binarypath" | grep ELF`" ]; then
        not_an_executable
    fi

    if [ -n "`file "$binarypath" | grep "32-bit"`" ]; then
        targetarch="x86"
    elif [ -n "`file "$binarypath" | grep "64-bit"`" ]; then
        targetarch="x86_64"
    else
        echo "Not a 32-bit or 64-bit binary"; echo `file "$binarypath"`; clean_up_err;
    fi

    # Change to the program's directory
    cd `dirname "$binarypath" || echo "cd $binarypath failed"; clean_up_err`
    binarypath=`basename "$binarypath"`

    # MJK
    # If there's a need to "exercise" this script, when there's NO need to
    # install any LIBs, then the next line could be changed slightly:

    dependencylist=`ldd "$binarypath" | grep "not found" | awk '{print $1}'`    #MJK - Live
    #dependencylist=`ldd "$binarypath" | grep "=>" | awk '{print $1}'`   #MJK - Tests

    neededlocallibraries=`echo "$dependencylist" | grep "\./"`
    if [ -n "$neededlocallibraries" ]; then
        neededlocallibraries=`echo ${neededlocallibraries//\.\//}`
        echo "You need to be copy the following libraries to the same directory as the binary:"
        echo "$neededlocallibraries"
        dependencylist=`echo "$dependencylist" | grep -v "\./"`
    fi
    
    if [ -z "`echo "$dependencylist" | grep "[[:alpha:]]"`" ]; then
        echo "This application isn't missing any dependencies"
	exit 0
    fi
    
    parameters="$dependencylist"
    library="true"
    binarypath="`pwd`/`basename "$binarypath"`"
fi

# Determine how to install library

if [ "$architecture" = "$targetarch" ]; then
    installtype="native" 	#apt-get
elif [ "$architecture" = "x86" ]; then
    echo "Cannot install 64-bit libraries on a 32-bit system"; clean_up_err;
else
    installtype="nonnative" 	#32-bit on 64-bit system
fi

# Loop - in case there are new dependencies created for binary

while true; do

    returned=""

    # Find the package name using the library filename

    if [ -n "$library" ]; then
        packagelist=""
        for lib in $parameters; do
            lib=`basename $lib`
            returned=`stored_list "$lib"`
            if [ -n "`echo "$lib" | grep "libGL.so."`" ]; then
                video_drivers
            elif [ -n "$aptfile" ]; then
                returned=`apt_file "$lib"`
                if [ -n "$returned" ]; then
                    packagelist="$packagelist$returned
"
                else
                    echo "Apt-file returned no results for $lib"
                fi
            elif [ -n "$returned" ]; then
                echo "$lib: $returned"
                packagelist="$packagelist$returned
"
            else
                returned=`use_web_interface "$lib"`
                if [ -n "$returned" ]; then
                    echo "$lib: $returned"

                    # MJK New test added (in case Comms is down)...

                    if [ ! "`echo "$returned" | grep "Not able to connect to"`" ]; then  #MJK
                        packagelist="$packagelist$returned
"
                    fi                                                                      #MJK

                else
                    echo "No match for $lib"
                fi
            fi
        done

        parameters="$packagelist"
        package="true"
    fi

    # If it is native, it can apt-get and stop here

    if [ "$installtype" = "native" ]; then
        if [ "`echo "$parameters" | grep "[[:alpha:]]"`" ]; then
            sudo apt-get install $parameters
        fi
        package=""
        parameters=""
        exit 0
    fi

    # If there are packages to download

    # MJK
    # If there's a need to "exercise" this script, when there's NO need to
    # install any LIBs, then the next line could be changed slightly:

    if [ -n "$package" ] && [ "`echo "$parameters" | grep "[[:alpha:]]"`" ]; then  #MJK - Live
    #if [ -n "$package" ] && [ -n "$parameters" ]; then     #MJK - Test
        # Sort list of names and download links
        parameters=`echo "$parameters" | sort -u`
        echo -n "The following i386 packages will be installed:"
        echo "$parameters"
        if [ -z "$prompt" ]; then
            echo -n "Continue [Y/n]? "
            read prompt
        fi
            case $prompt in
                [nN]) clean_up_err;;
                [nN][oO]) clean_up_err;;
                [yY]) ;;
                [yY][eE][sS]) ;;
                "") ;;
                *) echo "Not understood. Aborting."; clean_up_err;; #Default to "no"
            esac
    else
        if [ -n "$verbose" ]; then
            echo "No packages to download"
        fi
    fi

    # Find the download link using the name of the package

    if [ -n "$package" ]; then
        links=""
        mirrorlist=""
        for pack in $parameters; do
            templink=`apt-cache --no-all-versions show $pack | grep -o -m 1 '[^ ]*\.deb$'`
            if [ -n "$templink" ]; then
                linkmirror="`apt-cache policy $pack | grep -m 1 -i -o '\(http:\|www.\|ftp:\|https:\)[^ ]*'`"
                if [ -n "$linkmirror" ]; then
                    if [ -f "/etc/apt/sources.list" ]; then
                        linkmirror=`grep -o -m 1 "$linkmirror[^ ]*" /etc/apt/sources.list`
                    elif [ -f "/etc/apt/sources.lst" ]; then
                        linkmirror=`grep -o -m 1 "$linkmirror[^ ]*" /etc/apt/sources.lst`
                    else
                        echo "/etc/apt/sources.list not found"
                    fi
                    if [ -n "$linkmirror" ]; then
                        if [ -z "`echo $linkmirror | grep '/$'`" ]; then
                            linkmirror="$linkmirror/"
                        fi
                        mirrorlist="$mirrorlist$linkmirror "
                        templink="$linkmirror$templink"
                    fi
                fi
                if [ -n "$verbose" ]; then
                    echo "queue: $templink"
                    echo "mirror: $linkmirror"
                fi
                links="$links $templink"
            else
                echo "$pack was not found in your repositories"
                echo "Make sure you have all repositories enabled and updated"
            fi
        done
        links=`echo ${links//amd64\.deb/i386\.deb}`
        mirrorlist=`echo "$mirrorlist" | sort -u`
        parameters="$links"
        link="true"
    fi

    if [ -z "$mirror" ]; then
        if [ "$distro" = "Ubuntu" ]; then
            mirror2='http://mirrors.kernel.org/ubuntu/'
        else
            mirror2='http://mirrors.kernel.org/debian/'
        fi
    fi

    # Create the links to the packages

    if [ -n "$link" ]; then
        fulllinks=""
        for eachlink in $parameters; do
            if [ -z "`echo "$eachlink" | grep -i '\(http:\|www.\|ftp:\|https:\)'`" ]; then
                if [ -n "$verbose" ]; then
                    echo "$mirror2 is the new mirror for $eachlink"
                fi
                fulllinks="$fulllinks $mirror2$eachlink"
            else
                fulllinks="$fulllinks $eachlink"
            fi
        done

        parameters="$fulllinks"
        download="true"
    fi

    # Local file(s) to install

    if [ -n "$file" ]; then
        if [ "$architecture" = "x86" ]; then
            sudo dpkg -i $parameters; exit 0
        fi
        for eachfile in $parameters; do
            cp $eachfile $tempdir
        done
        parameters=""
        #build="true"
    fi

    # Download and install

    if [ -n "$download" ] && [ -n "`echo "$parameters" | grep "[[:alpha:]]"`" ]; then
        echo "Downloading ..."
        for eachlink in $parameters; do
            if [ -n "$verbose" ]; then
                echo "Downloading $eachlink"
            fi
            wget -q "--directory-prefix=$tempdir" "$eachlink"
            if [ $? -ne 0 ]; then
                echo "Failed to download file $eachlink"
                for eachmirror in $mirrorlist; do
                    eachlink=`echo ${eachlink//$eachmirror/$mirror2}`
                done
                wget -q "--directory-prefix=$tempdir" "$eachlink"
                if [ $? -ne 0 ]; then
                    wget_fail
                else
                    echo "$eachlink downloaded successfully from $mirror2"
                fi
            fi
        done
        #build="true"
    fi

    if [ -z "`ls $tempdir/*.deb 2> /dev/null`" ]; then
        echo "No packages to install"
        exit 0
    fi

    if [ -n "$build" ]; then 	#future default option
        mkdir "$tempdir/build"
        for eachdeb in `ls $tempdir/*.deb 2> /dev/null`; do
            if [ -n "$verbose" ]; then
                echo "extracting: $eachdeb"
            fi
            output=`dpkg_repack "$eachdeb"`
        done
    else 			# --extract
        for eachdeb in `ls $tempdir/*.deb`; do
            if [ -n "$verbose" ]; then
                echo "extracting: $eachdeb"
            fi
            dpkg -x "$eachdeb" "$tempdir/extracted"
        done

        echo "Installing libraries ..."
        ldconfigparam=""
        if [ "$distro" = "Ubuntu" ]; then
            if [ -d $tempdir/extracted/usr/lib/ ]; then #If dir exists (and thus files to move)
                sudo cp -R $tempdir/extracted/usr/lib/* /usr/lib32/ || copy_fail
                ldconfigparam="$ldconfigparam/usr/lib32/ "
            fi
            if [ -d $tempdir/extracted/lib/ ]; then 	#If dir exists (and thus files to move)
                sudo cp -R $tempdir/extracted/lib/* /lib32/ || copy_fail
                ldconfigparam="$ldconfigparam/lib32/ "
            fi
        elif [ "$distro" = "Debian" ]; then
            sudo cp -R $tempdir/extracted/* /emul/ia32-linux/ || copy_fail
            ldconfigparam="$ldconfigparam/emul/ia32-linux/ "
        fi
    fi

    # --ldconfig

    if [ -n "$ldconfig" ]; then
        sudo ldconfig -n $ldconfigparam
    fi

    # Check binary for new dependencies

    if [ -n "$binarypath" ]; then
        runningdependencylist="$runningdependencylist
$dependencylist"
        dependencylist=`ldd "$binarypath" | grep "not found" | awk '{print $1}' | grep -v "\./"`
        if [ -z "$dependencylist" ]; then
            exit 0 	# All dependencies satisfied
        fi

        for eachdependency in $runningdependencylist; do 
            dependencylist=`echo ${dependencylist//$eachdependency/}`    
        done
	dependencylist=`echo "$dependencylist" | grep "[[:alnum:]]"`
        if [ -n "$dependencylist" ]; then
            rm -rf $tempdir/*
            echo "New depedencies have been detected"
            parameters="$dependencylist"
        else
            exit 0 	# No new dependencies
        fi
    else
        exit 0
    fi

done
