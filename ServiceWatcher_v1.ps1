#create the function Watch-ServiceStatus
Function Watch-ServiceStatus {

    Param( [string]$Name,[boolean]$Notify )

    #create default email variables
    $User = "jhxcoal@gmail.com"
    
    #YOU NEED TO CREATE A FILE WITH THE PASSWORD. ENSURE THIS FILE IS ENCRYPTED BY USING "myPassword" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\EmailPassword.txt"#YOU NEED TO CREATE A FILE WITH THE PASSWORD. ENSURE THIS FILE IS ENCRYPTED BY USING "myPassword" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\EmailPassword.txt"
    #PLACE THIS FILE SOMEWHERE THE SCRIPT CAN GET TO IT. IN THIS EXAMPLE, ALL FILES FOR THE SCRIPT ARE LOCATED IN C:\Scripts\ServiceWatcher\
    $File = "C:\Scripts\ServiceWatcher\EmailPassword.txt" 
    
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)
    $EmailTo = "josh.henderson@xcoal.com" #WHO WILL RECEIVE THE EMAIL
    
    #If multiple emails are needed, add additional emails here
    $EmailTo2 = "Chris.Lynch@xcoal.com"
   
    $EmailFrom = "jhxcoal@gmail.com" #YOUR EMAIL HERE
    $SMTPServer = "smtp.gmail.com"  #THIS EXAMPLE USSES GMAIL
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
	
	#Uncomment the below if you need to send multiple emails
	#$SMTPClient.Send($SMTPMessage2)
        }
	
	#Uncomment below to start the service after sending the email
        #Start-Service $Name

    }

}

#Add a new line for each service needed to be monitored. Set -Notify to $true to send out the email. Note: the display name and the Servic name may be different be sure to check the service properties for the correct name
#Phone Service is used as an example. This service should already not be running so it works well for test
Watch-ServiceStatus -Name 'Phone Service' -Notify $true
#Watch-ServiceStatus -Name 'REPLACE WITH YOUR SERVICE' -Notify $true
