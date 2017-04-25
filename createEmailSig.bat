@echo off
set "location=c:\Emails\signature.html"

set /p name= Enter Your Name:
echo ^<br^>Regards>%location%
echo ^<br^>%name%>>%location%
echo ^<br^>FDC Accountants ^& Tax Ltd >>%location%
echo ^<br^>FDC House>>%location%

set /p street= Name of Street:
echo ^<br^>%street%>>%location%

set /p town= Name of Town:
echo ^<br^>%town%>>%location%

echo ^<br^> >>%location%

set /p pnum= Office Phone Number:
echo ^<br^>Tel: %pnum%>>%location%

set /p fnum= Office Fax Number:
echo ^<br^>Fax: %fnum%>>%location%

echo ^<!-- --^> >> %location%

echo ^<br^> >>%location%
echo ^<br^>Web: ^<a href='http://www.fdc.ie/'^>FDC Group^</a^> >>%location%

set /p email= Enter your Email Address:
echo ^<br^>Email: ^<a href='mailto: %email%'^>%email%^</a^> >>%location%

echo ^<br^> >>%location%
echo ^<br^>^<img src="http://www.fdc.ie/themes/ignite/08/skins/fdcgroup/images/logo.gif" width="150" height="50" /^> >>%location%
echo ^<br^>^<sub^> >>%location%
echo ^<p^>FDC Accountants ^& Tax Consultants Southern Region Limited, a private company limited by shares, registered in Ireland No.132122 with a registered office at FDC House, Wellington Road, Cork >>%location%
echo ^<br^> >>%location%
echo ^<br^>V.A.T Registered No: IE 4576414E. >>%location%
echo ^<br^> >>%location%
echo ^<br^>Directors: Jack Murphy, Barry Murphy>>%location%
echo ^<br^> >>%location%
echo ^<br^>This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed.  >>%location%
echo ^<br^>If you have received this e-mail in error please notify the system manager.  >>%location%
echo ^<br^>Please note that any views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of FDC.  >>%location%
echo ^<br^>Finally, the recipient should check this e-mail ^& any attachments for the presence of viruses.  >>%location%
echo ^<br^>FDC accepts no liability for any damage caused by any virus transmitted by this e-mail^</sub^>^</p^> >>%location%
