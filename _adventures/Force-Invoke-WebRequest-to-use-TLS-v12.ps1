# In case of getting errors on requests of some https:// site or api that uses TLS v1.2 and up
# It´s possible to change the protocol for Invoke-Command

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
