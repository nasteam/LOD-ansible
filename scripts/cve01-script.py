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
        "kerberos keyblocks delete",
        body={"encryption-type": "17,18", "service-type": "CIFS"},
        vserver="svm1_cluster1",
        privilege_level="diagnostic",
        poll=False,
    )
    print(json.dumps(response.http_response.json(), indent=4))
