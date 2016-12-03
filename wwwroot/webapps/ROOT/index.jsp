<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.File, java.io.FilenameFilter "%>

<%
try{
	if(request.getParameter("isreadycheck") != null) {
		File dirToScan = new File(System.getenv("HOME").concat("\\site\\wwwroot\\virtualapplicationwildfly"));

		File[] wfFolders = dirToScan.listFiles(new FilenameFilter()
		{
			public boolean accept(File dir, String name)
			{
				return dir.isDirectory() && name.startsWith(String.valueOf("WF_").concat(System.getenv("COMPUTERNAME")));
			}
		}); 

		for(File wfFolder : wfFolders)
		{
			File file = new File(wfFolder.getPath().concat("\\standalone\\deployments\\{yourwarname}.war.deployed"));
			while(!file.exists())
			{
				Thread.sleep(100);
			}
		}
	}
} catch(Exception ex) {
	System.err.println(ex);
} 
%>
