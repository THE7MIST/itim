echo "⚙️ Configuring Jenkins with default admin/admin..."

# Stop Jenkins if running
sudo systemctl stop jenkins || true

# Disable setup wizard
echo "JAVA_ARGS=\"-Djenkins.install.runSetupWizard=false\"" | \
  sudo tee /etc/default/jenkins > /dev/null

# Create basic security config
sudo mkdir -p /var/lib/jenkins

sudo tee /var/lib/jenkins/config.xml > /dev/null <<'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<hudson>
  <useSecurity>true</useSecurity>
  <securityRealm class="hudson.security.HudsonPrivateSecurityRealm">
    <disableSignup>true</disableSignup>
    <enableCaptcha>false</enableCaptcha>
  </securityRealm>
  <authorizationStrategy class="hudson.security.FullControlOnceLoggedInAuthorizationStrategy">
    <denyAnonymousReadAccess>true</denyAnonymousReadAccess>
  </authorizationStrategy>
</hudson>
EOF

# Create admin user manually
sudo mkdir -p /var/lib/jenkins/users/admin

sudo tee /var/lib/jenkins/users/admin/config.xml > /dev/null <<'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<user>
  <fullName>admin</fullName>
  <properties>
    <hudson.security.HudsonPrivateSecurityRealm_-Details>
      <passwordHash>#jbcrypt:$2a$10$7EqJtq98hPqEX7fNZaFWoOePaWxn96p36vU1u7Z0pniS3pSke1G6.</passwordHash>
    </hudson.security.HudsonPrivateSecurityRealm_-Details>
  </properties>
</user>
EOF

# Fix permissions
sudo chown -R jenkins:jenkins /var/lib/jenkins

echo "▶️ Starting Jenkins..."
sudo systemctl start jenkins