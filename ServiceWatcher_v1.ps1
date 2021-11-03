#create the function Watch-ServiceStatus
Function Watch-ServiceStatus {

    Param( [string]$Name,[boolean]$Notify )

    #create default email variables
    $User = "jhxcoal@gmail.com"
    $File = "C:\Scripts\ServiceWatcher\EmailPassword.txt"
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)
    $EmailTo = "josh.henderson@xcoal.com"
    $EmailTo2 = "Chris.Lynch@xcoal.com"
    $EmailFrom = "jhxcoal@gmail.com"
    $SMTPServer = "smtp.gmail.com" 
    $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
    $SMTPMessage2 = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo2,$Subject,$Body)
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
    $SMTPClient.EnableSsl = $true 
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($cred.UserName, $cred.Password); 
    
    #get the service status from the $Name variable
    $ServiceStatus = ( Get-Service $Name ).Status

    If ( $ServiceStatus -ne "Running" ) {

        If ( $Notify -eq $true ) {
        $Hostname = hostname
        $Subject = "Warning: $Name service is not running on $Hostname"
        $Body = "$Name service is not running on $Hostname"
        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
	$SMTPMessage2 = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo2,$Subject,$Body)
        $SMTPClient.Send($SMTPMessage)
	$SMTPClient.Send($SMTPMessage2)
        }

        #Start-Service $Name

    }

}

Watch-ServiceStatus -Name 'Phone Service' -Notify $true
Watch-ServiceStatus -Name 'RightAngle Service Monitor (20.0)' -Notify $true