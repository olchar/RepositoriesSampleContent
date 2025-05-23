param workspace string

resource workspace_ProofpointPODLargeOutboundEmails 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
  name: '${workspace}/ProofpointPODLargeOutboundEmails'
  location: resourceGroup().location
  properties: {
    eTag: '*'
    displayName: 'ProofpointPOD - Large size outbound emails'
    category: 'Hunting Queries'
    query: 'let starttime = todatetime(\'{{StartTimeISO}}\');\nlet endtime = todatetime(\'{{EndTimeISO}}\');\nlet lookback = starttime - 14d;\nlet out_msg = ProofpointPOD\n| where TimeGenerated between (lookback..starttime)\n| where EventType == \'message\'\n| where NetworkDirection == \'outbound\'\n| where SrcUserUpn != \'\';\nProofpointPOD\n| where TimeGenerated between(starttime..endtime)\n| where EventType == \'message\'\n| where NetworkDirection == \'outbound\'\n| where SrcUserUpn != \'\'\n| summarize AvgMsgSize = toint(avg(NetworkBytes_real)) by SrcUserUpn\n| join out_msg on SrcUserUpn\n| where NetworkBytes_real > AvgMsgSize*2\n| project SrcUserUpn, AvgMsgSize, NetworkBytes_real\n| extend AccountCustomEntity = SrcUserUpn\n'
    version: 1
    tags: [
      {
        name: 'description'
        value: 'Search for emails which size is 2 times grater than average size of outbound email for user.'
      }
      {
        name: 'tactics'
        value: 'Exfiltration'
      }
    ]
  }
}
