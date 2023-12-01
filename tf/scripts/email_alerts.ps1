param(
    [Parameter(Mandatory = $true)]
    $to_email,
    [Parameter(Mandatory = $true)]
    $from_email,
    [Parameter (Mandatory=$false)]
    [object] $WebhookData
)

$today = (Get-Date).Date

#Make this generic for all env
$uri = "https://erx-test-east-us.azure-api.net/profile/SendMailFunction"


if ($WebhookData)
{
    # Get the data object from WebhookData
    $WebhookBody = (ConvertFrom-Json -InputObject $WebhookData.RequestBody)

    # Get the info needed to identify the VM (depends on the payload schema)
    $schemaId = $WebhookBody.schemaId
    Write-Verbose "schemaId: $schemaId" -Verbose
    if ($schemaId -eq "azureMonitorCommonAlertSchema") {
        # This is the common Metric Alert schema (released March 2019)
        $Essentials = [object] ($WebhookBody.data).essentials
        $Alert_Context = [object] ($WebhookBody.data).alertContext
        $Properties    = [object] ($WebhookBody.data).alertContext.properties
        # Get the first target only as this script doesn't handle multiple
        $alertTargetIdArray = (($Essentials.alertTargetIds)[0]).Split("/")
        $SubId = ($alertTargetIdArray)[2]
        $ResourceGroupName = ($alertTargetIdArray)[4]
        $ResourceType = ($alertTargetIdArray)[6] + "/" + ($alertTargetIdArray)[7]
        $ResourceName = ($alertTargetIdArray)[-1]
        $status = $Essentials.monitorCondition
        $severity = $Essentials.severity
        $desc    = $Essentials.description
        $firedDateTime = $Essentials.firedDateTime
        $monitoringService = $Essentials.monitoringService
        $signalType      = $Essentials.signalType
        $alertId   = $Essentials.alertId
        $alertRule   = $Essentials.alertRule
        $eventDataId = $Alert_Context.eventDataId
        $level   = $Alert_Context.level
        $Operation_name = $Alert_Context.operationName
        $eventSource = $Alert_Context.eventSource
        $Channels    = $Alert_Context.Channels
        #$status      = $Alert_Context.status
        $operationName = $Alert_Context.operationName
        $title         = $Properties.title
        $cause         = $Properties.cause
        $type   = "1"
    }
    elseif ($schemaId -eq "AzureMonitorMetricAlert") {
        # This is the near-real-time Metric Alert schema
        $AlertContext = [object] ($WebhookBody.data).context
        $SubId = $AlertContext.subscriptionId
        $ResourceGroupName = $AlertContext.resourceGroupName
        $ResourceType = $AlertContext.resourceType
        $ResourceName = $AlertContext.resourceName
        $status = ($WebhookBody.data).status
        $type   = "2"
    }
    elseif ($schemaId -eq "Microsoft.Insights/activityLogs") {
        # This is the Activity Log Alert schema
        $AlertContext = [object] (($WebhookBody.data).context).activityLog
        $SubId = $AlertContext.subscriptionId
        $ResourceGroupName = $AlertContext.resourceGroupName
        $ResourceType = $AlertContext.resourceType
        $ResourceName = (($AlertContext.resourceId).Split("/"))[-1]
        $status = ($WebhookBody.data).status
        $type   = "3"
    }
    elseif ($schemaId -eq $null) {
        # This is the original Metric Alert schema
        $AlertContext = [object] $WebhookBody.context
        $SubId = $AlertContext.subscriptionId
        $ResourceGroupName = $AlertContext.resourceGroupName
        $ResourceType = $AlertContext.resourceType
        $ResourceName = $AlertContext.resourceName
        $status = $WebhookBody.status
        $type   = "4"
    }
    else {
        # Schema not supported
        Write-Error "The alert data schema - $schemaId - is not supported."
    }
}
else {
    # Error
    Write-Error "This runbook is meant to be started from an Azure alert webhook only."
}


#common function to send email
function Send-Email
{
    [CmdletBinding()]  
    param
    (
        [ Parameter (Mandatory = $true)]  
        [string]$uri,
        [ Parameter (Mandatory = $true)]  
        [string]$to_email,
        [ Parameter (Mandatory = $true)]  
        [string]$from_email,
        [ Parameter (Mandatory = $true)]  
        [string]$subject,
        [ Parameter (Mandatory = $true)]  
        [string]$body
    )
    $JSONBody = [PSCustomObject][Ordered]@{
        "From" = $from_email
        "To" = $to_email
        "Subject" = $subject
        "Body" = $body
    }
    $TeamMessageBody = ConvertTo-Json $JSONBody
    $parameters = @{
        "URI" = $uri
        "Method" = 'POST'
        "Body" = $TeamMessageBody
        "ContentType" = 'application/json'
    }
    Invoke-RestMethod @parameters
}

#Splitting Fire Date and Time
$fireDateArr = $firedDateTime.Split("T")
$fireDate    = $fireDateArr[0]
Write-Output $fireDate

#Removing Z character
$fireTimeArr = $fireDateArr[1].Split(".")
$fireTime    = $fireTimeArr[0]
Write-Output $fireTime

$subject= "$level $monitoringService Alert triggered for resource $ResourceName "
$body = "<html>
            <head>
                <style>
                    table 
                    {
                        font-family: arial, sans-serif;
                        border-collapse: collapse;
                        width: 100%;
                    }
                    td 
                    {
                        border: 1px solid #dddddd;
                        text-align: left;
                        padding: 8px;
                        font-weight: bold;
                    }
                    h1 { font-weight: normal; }
                </style>
            </head>
            <body>
                <h1><strong>$level $monitoringService Alert triggered </strong><br><br> <strong>Alert Rule:</strong>&emsp;&emsp; $alertRule <br> <strong>Resource:</strong>&emsp;&ensp;&ensp;&nbsp;&nbsp; $ResourceName <br> <strong>Resource Type:</strong> $ResourceType <br> <strong>Time:</strong>&ensp;&emsp;&emsp;&emsp;&ensp;&nbsp;&nbsp; $fireDate $fireTime UTC <br><br></h1>
                <h2> Summary </h2>
                <table border='1'>
                <tr>
                    <td>Alert name</td>
                    <td>$alertRule</td>
                </tr>
                <tr>
                    <td>Level</td>
                    <td>$level</td>
                </tr>
                <tr>
                    <td>Affected resource</td>
                    <td>$ResourceName</td>
                </tr>
                <tr>
                    <td>Resource Type</td>
                    <td>$ResourceType</td>
                </tr>
                <tr>
                    <td>Resource Group</td>
                    <td>$ResourceGroupName</td>
                </tr>
                <tr>
                    <td>Alert Title</td>
                    <td>$title</td>
                <tr>
                <tr>
                    <td>Alert Cause</td>
                    <td>$cause</td>
                <tr>
                    <td>Alert Description</td>
                    <td>$desc</td>
                </tr>
                <tr>
                    <td>Monitoring Service</td>
                    <td>$monitoringService</td>
                </tr>
                <tr>
                    <td>signalType</td>
                    <td>$signalType</td>
                </tr>
                <tr>
                    <td>Fired Time</td>
                    <td>$fireDate $fireTime UTC</td>
                </tr>
                <tr>
                    <td>Alert Id</td>
                    <td>$alertId</td>
                </tr>
                <tr>
                    <td>Event Source</td>
                    <td>$eventSource</td>
                </tr>
                <tr>
                    <td>Channels</td>
                    <td>$Channels</td>
                </tr>
                <tr>
                    <td>Event Data Id</td>
                    <td>$eventDataId</td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td>$status</td>
                </tr>
                <tr>
                    <td>Operation Name</td>
                    <td>$operationName</td>
                </tr>
                </table>
            </body>
        </html>"

Send-Email -uri $uri -to_email $to_email -from_email $from_email -subject $subject -body $body
Write-Output "Sending resource health alert to $to_email"

