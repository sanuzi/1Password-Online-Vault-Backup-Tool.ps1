# 1Password-Online-Vault-Backup-Tool.ps1

For those of us who don't trust 1password to solely maintain and store our sensitive data

------------------------------------

** can set to automatically run by adding as a task via windows task scheduler **

** see: https://o365reports.com/2019/08/02/schedule-powershell-script-task-scheduler **

------------------------------------

 PRE-REQS                     

 * download op cli (https://app-updates.agilebits.com/product_history/CLI) and add to PATH

 * use op cli to manually log into 1password via cli for the first time (you won't have to do this again)
   
 * * run the following in your powershell client: 
        
        op signin my.1password.com email@domain.com

 * * this will add your account to the windows cache; from this point on, you can execute this shorthand to sign in: 
        
        op signin
