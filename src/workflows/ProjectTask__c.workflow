<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Task_Completed</fullName>
        <description>Task Completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <template>Custom_templates/Task_Completed</template>
    </alerts>
    <rules>
        <fullName>Project Task Completed</fullName>
        <actions>
            <name>Task_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>ProjectTask__c.PercentCompleted__c</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>ProjectTask__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed,Resolved</value>
        </criteriaItems>
        <description>Project Task Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
