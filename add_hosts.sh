#!/bin/bash
echo "Adding subdomain entries to /etc/hosts..."
echo "You will need to enter your password for sudo access."

# Add the subdomain entries
sudo sh -c 'echo "127.0.0.1	agency.localhost" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1	admin.localhost" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1	client.localhost" >> /etc/hosts'

echo "Done! The following entries have been added:"
echo "127.0.0.1	agency.localhost"
echo "127.0.0.1	admin.localhost"
echo "127.0.0.1	client.localhost"

echo ""
echo "You can now access:"
echo "- Agency login at: http://agency.localhost:3000/agency/sign_in"
echo "- Admin login at: http://admin.localhost:3000/admin/sign_in"
echo "- User/Client login at: http://client.localhost:3000/user/sign_in"