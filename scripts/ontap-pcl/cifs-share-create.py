# Import everything needed
from netapp_ontap import config, NetAppRestError, HostConnection
from netapp_ontap.resources import Volume, CifsService, CifsShare, Svm
import getpass

# Fill out cluster details
cluster = input("What is the hostname or IP of the cluster? ")
admin_user = input("What is the login name for the cluster? ")
admin_password = getpass.getpass("Please enter the login password: ")
svm_name = input("Which vserver do you want to create shares for? ")

# Establish the connection to the NetApp cluster
connection = HostConnection(
    host=cluster,
    username=admin_user,
    password=admin_password,
    verify=False  # SSL verification; False because Labs don't have good certs
)

config.CONNECTION = connection

try:
    # Get all volumes that aren't svm_root
    for volume in Volume.get_collection(svm=svm_name, is_svm_root=False):
        volume.get()

        # Skip S3 FlexGroups
        if volume.name.startswith('fg_oss'):
        	continue
        	
        # Map share names to vol names
        cifs_share_name = f"{volume.name}"
          
        try:
        	# Create a CIFS share for the volume
        	cifs_share = CifsShare.from_dict({
            	"name": cifs_share_name,
            	"svm": {"name": svm_name},
            	"path": f"/{volume.name}"
        	})
        	cifs_share.post()
        	print(f"CIFS share '{cifs_share_name}' created for volume '{volume.name}'.")
        	
        except NetAppRestError as e:
			# Continue on duplicate entry
            if "duplicate entry" in str(e).lower():
                print(f"Skipped creating CIFS share for volume '{volume.name}' because it already exists.")
                continue
            else:
                # If the error is not a duplicate entry, raise it
                raise	

except NetAppRestError as e:
    print(f"An error occurred: {e}")
