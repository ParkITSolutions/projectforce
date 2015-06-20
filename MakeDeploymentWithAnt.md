# To do the deployment with the command "ant" you have to do the following steps: #

1. Go to the "Source" tab. From here you'll get the url and the user to input into the SVN Checkout.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeSource.png' />

2. To enable the deployment, you must have the TortoiseSVN program installed or another SVN clients. [To download the TortoiseSVN click  here](http://tortoisesvn.net/downloads)

3. Create a folder where you want to save the project.

4. Inside the created folder make click in the right mouse button and select the SVN Checkout... option.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/SVNCheckout.png' />

5. Enter a URL obtained in step 1 and click on OK button.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/SVNCheckoutWindow.png' />

6. Enter the SVN username and the SVN password obtained in the step 1.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/SVNAutentication.png' />

7. The project creates in the folder.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeFolder.png' />

8. Make double click in the trunk folder.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeTrunkFolder.png' />

9. Edit the build.properties file and save the changes.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeBuildPropertiesFile.PNG' />

10. You must have the ANT program installed.
[To download the Apache-ANT click  here](http://ant.apache.org/bindownload.cgi)

11. In the folder lib of the apache-ant installed, add file ant-salesforce.jar. To get the ant-salesforce.jar file go to the ant folder.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeAntFolder.PNG' />

12. To excecute the ANT command you must open the console.

13. Go to the directory which contains the build.properties and buil.xml files, in the trunk folder.


14. Excecute the ANT command.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeAntCommand.PNG' />

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeDeploy.PNG' />

15. At the end of the deployment you will see this screen.

<img src='http://projectforce.googlecode.com/svn/wiki/images/DeploymentWithAnt/GoogleCodeAntCommandFinished.png' />