/**
* @author Miguel Soares
* @createdDate 04/15/2009
*/
@isTest private class PaginatorControllerTest {
	
	/**
    * Test PaginatorController
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		PaginatorController n = new PaginatorController();
        n.setNumberOfItemsToShow(8);
        n.setTotalItemsNumber(10);
        Integer totalItem = n.getTotalItemsNumber();
        if(totalItem == null){
                System.assert(false, 'No Items'); 
        }
        boolean disabled = n.getdisabledInput();
        if(disabled == null){
                System.assert(false, 'No set Disabled'); 
        }
        n.genCntPagination();
        n.nextPage();
        n.prevPage();
        n.lastPage();
        n.firstPage();
        n.refreshPages();
        Integer firstI = n.getFirstItem();
        if(firstI == null){
                System.assert(false, 'Error First Item'); 
        }
        Integer lastI = n.getLastItem();
        if(lastI == null){
                System.assert(false, 'Error last Item'); 
        }
        Integer currentP = n.getCurrentPagination();
        if(currentP == null){
                System.assert(false, 'Error Current paginator Item'); 
        }
        Integer cntP = n.getCntPagination();
        if(cntP == null){
                System.assert(false, 'Error cnt paginator Item'); 
        }   
        Integer numberToShow = n.getNumberOfItemsToShow();
        if(numberToShow == null){
                System.assert(false, 'Error number To Show Item'); 
        }
        Integer firstRow = n.getFirstRow();
        if(firstRow == null){
                System.assert(false, 'Error first Row Item'); 
        }
        boolean prevP = n.getPrevPageLinkShow();
        if(prevP == null){
                System.assert(false, 'Error Prev Page Link Show Item'); 
        }
        boolean prevPa = n.getPrevPageShow();
        if(prevPa == null){
                System.assert(false, 'Error Prev Page Item'); 
        }
        boolean NextP = n.getNextPageLinkShow();
        if(NextP == null){
                System.assert(false, 'Error Next Page Link Show Item'); 
        }
        boolean NextPa = n.getNextPageShow();
        if(NextPa == null){
                System.assert(false, 'Error next Page Item'); 
        }
        Integer jumpto = n.getJumpPage();
        if(jumpto == null){
                System.assert(false, 'Error Jump Page Item'); 
        }
        n.setJumpPage(12);
        n.JumpToPage();
 
        n.getPrevPageLinkShow();
        n.getPrevPageShow();
        n.getNextPageLinkShow();
        n.getNextPageShow();       
        
        n.clearPagination();
        
        n.setPrevPageShow(true); 
        n.setNextPageShow(true);
        n.getdisabledInput();
        
        n.setCurrentPagination(1);
        n.setCntPagination(1);
        n.getLastItem();
        
        n.setCurrentPagination(2);
        n.setCntPagination(1);
        n.getLastItem();
        
        n.setCntPagination(3);
        n.setJumpPage(2);
        n.JumpToPage();
        
        n.setJumpPage(0);
        n.JumpToPage();    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}