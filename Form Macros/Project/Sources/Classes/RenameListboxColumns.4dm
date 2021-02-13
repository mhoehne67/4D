/*
Form Macro to rename listbox columns, column headers and footers according to the name of the listbox.
Author: Michael Höhne

-------------------------------------------------------------------------------

The column, header and footer names of a listbox with object name "oLbxCompanies" will be set to:

  oLbxCompaniesCol1
  oLbxCompaniesCol1Header
  oLbxCompaniesCol1Footer

  oLbxCompaniesCol2
  oLbxCompaniesCol2Header
  oLbxCompaniesCol2Footer

and so on.

You can easily apply your own naming scheme.
If renaming an object would lead to duplicate object names, the entire process is aborted (see ABORT in this class)

-------------------------------------------------------------------------------

To use this class as a form macro, you need to insert the following snippet to your /project/sources/formMacros.json file:

 {
   "macros": {

>--- snip start ---<
     "Rename ListBox Columns": {
       "class": "RenameListBoxColumns"
     },
>--- snip end ---<  

     "0- Open Macros file": {
       "class": "OpenMacro"
     },   

     "1- Set Red": {
       "class": "SetRedColor"
     },

...

   }
 }

If there is no /project/sources/formMacros.json file, then simply create it with your favorite text editor. 

Further information can be found here:
-------------------------------------------------------------------------------
https://blog.4d.com/automate-repetitive-tasks-and-more-with-form-macros/
https://blog.4d.com/6-practical-examples-on-how-to-use-macros/
https://developer.4d.com/docs/en/FormEditor/macros.html

*/

Class constructor($macro : Object)
	This:C1470.editor:=Null:C1517  // editor property of form editor macro proxy instance - passed in onInvoke
	
	
	// Macro invoked in the form designer.
Function onInvoke($editor : Object)->$return : Object
	var $objectName : Text
	var $formObject : Object
	
	This:C1470.editor:=$editor.editor
	
	If (This:C1470.editor.currentSelection.length>0)
		
		For each ($objectName; This:C1470.editor.currentSelection)
			$formObject:=This:C1470.editor.currentPage.objects[$objectName]
			
			If (This:C1470.isListbox($formObject))
				This:C1470.renameListboxColumns($objectName; $formObject)
			End if 
		End for each 
	End if 
	
	// Return the modified page object
	$return:=New object:C1471("currentPage"; This:C1470.editor.currentPage)
	
	
	// Checks if the form object is a listbox
Function isListbox($formObject : Object)->$isListbox : Boolean
	$isListbox:=($formObject.type="listbox")
	
	
	// Generic error handler if something unexpected happens.
Function onError($editor : Object; $resultMacro : Object; $error : Collection)
	ALERT:C41($error.extract("message").join("\n"))
	
	
	// Renames all columns, column headers and footers based on 
	// the listbox object name. 
Function renameListboxColumns($lbxName : Text; $listbox : Object)
	var $col : Object
	var $index : Integer
	
	$index:=1
	
	For each ($col; $listbox.columns)
		This:C1470.setObjectName($col; $lbxName+"Col"+String:C10($index))
		This:C1470.setObjectName($col.footer; $col.name+"Footer")
		This:C1470.setObjectName($col.header; $col.name+"Header")
		
		$index:=$index+1
	End for each 
	
	
	// Changes the object name of $formObject to the $newObjectName. 
	// If the new object name is different than the current name 
	// and form object with that name already exists on any page
	// of the form, the processing is aborted and a message is shown
	// in the designer.
Function setObjectName($formObject : Object; $newObjectName : Text)
	If ($newObjectName#$formObject.name)
		
		If (This:C1470.isObjectNameUsedInForm(This:C1470.editor.form; $newObjectName))
			ALERT:C41("Object name "+$newObjectName+" already used. Renaming canceled.")
			ABORT:C156  // abort further processing
		Else 
			$formObject.name:=$newObjectName
		End if 
		
	End if 
	
	
	// Checks if an object with name $objectName is present on any of the pages of form $form.
Function isObjectNameUsedInForm($form : Object; $objectName : Text)->$isUsed : Boolean
	var $page : Object
	$isUsed:=False:C215
	
	For each ($page; $form.pages) While (Not:C34($isUsed))
		$isUsed:=This:C1470.isObjectNameUsedInPage($page; $objectName)
	End for each 
	
	
	// Checks if an object with name $objectName is present on page $page.
Function isObjectNameUsedInPage($page : Object; $objectName : Text)->$isUsed : Boolean
	$isUsed:=Not:C34(Undefined:C82($page.objects[$objectName]))
	
	If (Not:C34($isUsed))
		var $formObjectName : Text
		var $formObject : Object
		
		For each ($formObjectName; $page.objects) While (Not:C34($isUsed))
			$formObject:=$page.objects[$formObjectName]
			
			If (This:C1470.isListbox($formObject))
				$isUsed:=This:C1470.isObjectNameUsedInListbox($formObject; $objectName)
			End if 
		End for each 
	End if 
	
	
	// Checks if an object with name $objectName is present in a listbox column, header or footer
Function isObjectNameUsedInListbox($listbox : Object; $objectName : Text)->$isUsed : Boolean
	var $col : Object
	$isUsed:=False:C215
	
	For each ($col; $listbox.columns) While (Not:C34($isUsed))
		$isUsed:=($col.name=$objectName) | ($col.footer.name=$objectName) | ($col.header.name=$objectName)
	End for each 
	