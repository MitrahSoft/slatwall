<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.product#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.product#" edit="#rc.edit#">
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="updateSkus" type="list" modal="true" />
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.processproduct" processContext="updateDefaultImageFileNames" type="list" confirm="true" confirmtext="#$.slatwall.rbKey('entity.Product.process.updateDefaultImageFileNames_confirm')#" />
			<li class="divider"></li>
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" type="list" modal="true" />
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" type="list" modal="true" />
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSku" type="list" modal="true" />
			<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" type="list" modal="true" />
			<hb:HibachiActionCaller action="admin:entity.createImage" querystring="productID=#rc.product.getProductID()#&objectName=product&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<hb:HibachiActionCaller action="admin:entity.createfile" querystring="baseObject=#rc.product.getClassName()#&baseID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<hb:HibachiActionCaller action="admin:entity.createcomment" querystring="productID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList divClass="span6">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
			</hb:HibachiPropertyList>
			<hb:HibachiPropertyList divClass="span6">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
				<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
				<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
		<hb:HibachiTabGroup object="#rc.product#">
			<!--- Skus --->
			<hb:HibachiTab property="skus" />
			
			<!--- Images --->
			<hb:HibachiTab view="admin:entity/producttabs/images" />
			
			<!--- Files --->
			<swa:SlatwallAdminTabFiles object="#rc.product#" />
			
			<!--- Description --->
			<hb:HibachiTab property="productDescription" />
			
			<!--- Relating --->
			<hb:HibachiTab property="listingPages" />
			<hb:HibachiTab property="categories" />
			<hb:HibachiTab property="relatedProducts" />
			
			<!--- Reference --->
			<hb:HibachiTab property="productReviews" />
			<hb:HibachiTab property="vendors" />
			
			<!--- Settings --->
			<hb:HibachiTab view="admin:entity/producttabs/productsettings" />
			<hb:HibachiTab view="admin:entity/producttabs/skusettings" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.product.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<swa:SlatwallAdminTabCustomAttributes object="#rc.product#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<swa:SlatwallAdminTabComments object="#rc.product#" />
		</hb:HibachiTabGroup>
		
	</hb:HibachiEntityDetailForm>

</cfoutput>
