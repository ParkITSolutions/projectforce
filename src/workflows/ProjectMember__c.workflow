<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_Adding_Project_Members</fullName>
        <description>Email Alert for Adding Project Members</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <template>Custom_templates/Adding_Project_Members</template>
    </alerts>
    <rules>
        <fullName>Project Member Added</fullName>
        <actions>
            <name>Email_Alert_for_Adding_Project_Members</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Rule for Sending emails to newl added users to project</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
