<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_Adding_Task_Assignees</fullName>
        <description>Email Alert for Adding Task Assignees</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <template>Custom_templates/Adding_Task_Assignee</template>
    </alerts>
    <rules>
        <fullName>Add Task Assignee</fullName>
        <actions>
            <name>Email_Alert_for_Adding_Task_Assignees</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Add Task Assignee</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
