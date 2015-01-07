# Use latest jboss/base-jdk:7 image as the base
FROM jboss/base-jdk:7

# Maintainer details
MAINTAINER Andrew Block "andy.block@gmail.com"

# Environment Variables 
ENV BPMS_HOME /opt/jboss/bpms

# ADD Installation Files
ADD support/installation-bpms support/installation-bpms.variables installs/jboss-bpms-installer-6.0.3.GA-redhat-1.jar /opt/jboss/

# Modify Variables file for Docker build
RUN  sed -i "s:<installpath>.*</installpath>:<installpath>$BPMS_HOME</installpath>:" /opt/jboss/installation-bpms

# Run BPMS Installation
RUN java -jar /opt/jboss/jboss-bpms-installer-6.0.3.GA-redhat-1.jar /opt/jboss/installation-bpms -variablefile /opt/jboss/installation-bpms.variables


# Add support files
ADD support/application-roles.properties $BPMS_HOME/jboss-eap-6.1/standalone/configuration/
ADD support/standalone.xml $BPMS_HOME/jboss-eap-6.1/standalone/configuration/

USER root

# Remove standalone history directory to avoid startup issues
RUN chown -R jboss:jboss /opt/jboss && rm -rf /opt/jboss/jboss-bpms-installer-6.0.3.GA-redhat-1.jar /opt/jboss/installation-bpms /opt/jboss/installation-bpms.variables $BPMS_HOME/jboss-eap-6.1/standalone/configuration/standalone_xml_history/

# Run as JBoss 
USER jboss

# Expose Ports
EXPOSE 9990 9999 8080

# Run BPMS
CMD ["/opt/jboss/bpms/jboss-eap-6.1/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
