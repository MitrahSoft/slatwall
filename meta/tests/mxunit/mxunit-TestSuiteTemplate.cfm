<!--- 
 Note that there are not HTML tags as these are generated by the XSL
 found in the TestResult.cfc component. Alternatively, you could use
 the mxunit.TestResult.getXMLDomResults() and pass in the optional
 XSL argument, your custom XSL. You could also just use the
 mxunit.TestResult.getResults() method to get the raw XML.

 --->

<cfscript>
 testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite(); //TestSuite() is the constructor
 testSuite.addAll("path.to.myTest");
 testSuite.addAll("path.to.myOtherTest"); 
 //Create mxunit.framework.TestResult object
 results = testSuite.run();
</cfscript>
 
<!--- Output the results --->  
<cfoutput>#results.getHtmlResults()#</cfoutput>  