Install-Module PowerShellGet
Install-Module -Name MicrosoftTeams
Write-Host hi, the popup that authenticates you might not spring infornt of you but the window will glow red on the taskbar -ForeGround red
Connect-MicrosoftTeams

$CSVfile = Read-Host "Enter Path To CSV File" 
$AllTeams = Get-Team 
$output = @()
$i = 0 
Foreach ($Team in $AllTeams)
    {
    $AllChannels = Get-TeamChannel -GroupID $Team.GroupID
    Foreach ($Channel in $AllChannels)
        {
        $AllMembers = Get-TeamChannelUser -GroupId $Team.GroupID -DisplayName $Channel.DisplayName
        Foreach ($member in $AllMembers)
            {
            $userObject = New-Object PSObject
            $userObject | Add-Member NoteProperty -Name "DisplayName" -Value $member.Name
            $userObject | Add-Member NoteProperty -Name "UserId" -Value $member.UserId
            $userObject | Add-Member NoteProperty -Name "User SMTP Address" -Value $member.User
            $userObject | Add-Member NoteProperty -Name "Role" -Value $member.role
            $userObject | Add-Member NoteProperty -Name "Channel DisplayName" -Value $Channel.DisplayName
            $userObject | Add-Member NoteProperty -Name "Channel Description" -Value $Channel.Description
            $userObject | Add-Member NoteProperty -Name "Channel MembershipType" -Value $Channel.MembershipType
            $userObject | Add-Member NoteProperty -Name "Team GroupID" -Value $Team.GroupId
            $userObject | Add-Member NoteProperty -Name "Team DisplayName" -Value $Team.DisplayName

            $output += $userObject  
            }
        }
    $i++
    Write-Progress -activity "Scanning" -status "$i of $($AllTeams.Count)" 
    }

$output | Export-csv -Path $CSVfile -NoTypeInformation -Encoding UTF8
Write-Host bye