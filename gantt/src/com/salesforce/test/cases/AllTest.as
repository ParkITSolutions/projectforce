package com.salesforce.test.cases
{
	
	import com.salesforce.test.cases.chart.delet3.*;
	import com.salesforce.test.cases.chart.create.*;
	import com.salesforce.test.cases.chart.edit.*;
	import com.salesforce.test.cases.chart.makeparentchildtask.*;
	import com.salesforce.test.cases.chart.navigator.*;
	import com.salesforce.test.cases.chart.redochanges.*;
	import com.salesforce.test.cases.chart.undochanges.*;
	import com.salesforce.test.cases.tasklist.create.*;
	import com.salesforce.test.cases.tasklist.delet3.*;
	import com.salesforce.test.cases.tasklist.edit.*;
	
	import flexunit.framework.TestSuite;
	
	public class AllTest
	{
		 public static function getAllTests() : TestSuite { 
			var testSuite:TestSuite = new TestSuite();
			testSuite.addTestSuite(TestCaseChartCreateTask01);
            testSuite.addTestSuite(TestCaseChartCreateTask03);
            testSuite.addTestSuite(TestCaseChartCreateTask04);
            testSuite.addTestSuite(TestCaseChartCreateTask09);
            testSuite.addTestSuite(TestCaseChartDeleteTask01);
            testSuite.addTestSuite(TestCaseChartDeleteTask02);
            testSuite.addTestSuite(TestCaseChartDeleteTask03);
            testSuite.addTestSuite(TestCaseChartDeleteTask04);
            testSuite.addTestSuite(TestCaseChartDeleteTask05);
            testSuite.addTestSuite(TestCaseChartEditTask01);
            testSuite.addTestSuite(TestCaseChartEditTask02);
            testSuite.addTestSuite(TestCaseChartEditTask03);
            testSuite.addTestSuite(TestCaseChartEditTask04);
            testSuite.addTestSuite(TestCaseChartEditTask05);
            testSuite.addTestSuite(TestCaseChartEditTask06);
            testSuite.addTestSuite(TestCaseChartEditTask09);
            testSuite.addTestSuite(TestCaseChartEditTask11);
            testSuite.addTestSuite(TestCaseChartEditTask12);
            testSuite.addTestSuite(TestCaseChartEditTask13);
            testSuite.addTestSuite(TestCaseChartEditTask14);
            testSuite.addTestSuite(TestCaseMakeParenChildTask01);
            testSuite.addTestSuite(TestCaseMakeParenChildTask02);
            testSuite.addTestSuite(TestCaseMakeParenChildTask03);
            testSuite.addTestSuite(TestCaseMakeParenChildTask04);
            testSuite.addTestSuite(TestCaseMakeParenChildTask05);
            testSuite.addTestSuite(TestCaseMakeParenChildTask06);
            testSuite.addTestSuite(TestCaseMakeParenChildTask07);
            testSuite.addTestSuite(TestCaseMakeParenChildTask08);
            testSuite.addTestSuite(TestCaseChartNavigatorTask01);
            testSuite.addTestSuite(TestCaseChartNavigatorTask02);
            testSuite.addTestSuite(TestCaseChartNavigatorTask03);
            testSuite.addTestSuite(TestCaseChartRedoChanges01);
            testSuite.addTestSuite(TestCaseChartRedoChanges02);
            testSuite.addTestSuite(TestCaseChartRedoChanges03);
            testSuite.addTestSuite(TestCaseChartRedoChanges04);
            testSuite.addTestSuite(TestCaseChartRedoChanges05);
            testSuite.addTestSuite(TestCaseChartRedoChanges06);
            testSuite.addTestSuite(TestCaseChartUndoChanges01);
            testSuite.addTestSuite(TestCaseChartUndoChanges02);
            testSuite.addTestSuite(TestCaseChartUndoChanges03);
            testSuite.addTestSuite(TestCaseChartUndoChanges04);
            testSuite.addTestSuite(TestCaseChartUndoChanges05);
            testSuite.addTestSuite(TestCaseChartUndoChanges06);
            testSuite.addTestSuite(TestCaseTaskListCreateTask01);
            testSuite.addTestSuite(TestCaseTaskListCreateTask02);
            testSuite.addTestSuite(TestCaseTaskListCreateTask03);
            testSuite.addTestSuite(TestCaseTaskListCreateTask04);
            testSuite.addTestSuite(TestCaseTaskListCreateTask05);
            testSuite.addTestSuite(TestCaseTaskListDeleteTask01);
            testSuite.addTestSuite(TestCaseTaskListDeleteTask02);
            testSuite.addTestSuite(TestCaseTaskListEditTask01);
            testSuite.addTestSuite(TestCreateTasks); 
			return testSuite;
	    }
	}
}