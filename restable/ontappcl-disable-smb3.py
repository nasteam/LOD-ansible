# Allow json responses
import json
# Global configuration for the library
from netapp_ontap import config
# Support for the connection to ONTAP
from netapp_ontap import HostConnection
# Import CLI API to run diag commands
from netapp_ontap.resources import CLI
# Create connection to the ONTAP management LIF
# Attempt to modify CIFS diag option
with HostConnection("192.168.0.101", username="admin",
password="Netapp1!", verify=False):
    response = CLI().execute(
        "cifs options modify",
        body={"smb3-enabled": "false", "smb31-enabled": "false"},
        vserver="svm1_cluster1",
        privilege_level="diagnostic",
        poll=False,
    )
