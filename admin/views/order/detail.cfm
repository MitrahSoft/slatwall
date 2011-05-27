<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.Order" type="any" />

<cfoutput>
<div class="svoadminorderdetail">
	<dl class="twoColumn">
		<cf_PropertyDisplay object="#rc.Order#" property="OrderID" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Order#" property="OrderOpenDateTime" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Order.getAccount()#" property="fullName" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Order.getOrderStatusType()#" property="Type" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Order#" property="OrderTotal" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Order#" property="filename" edit="#rc.edit#">
	</dl>
	<h3 class="tableheader">Order Items</h3>
	<table class="strips">
		<tr>
			<th>#$.slatwall.rbKey('entity.brand.brandname')#</th>
			<th class="varWidth">#$.slatwall.rbKey('entity.product.productname')#</th>
			<th>Options</th>
			<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
			<th>#$.slatwall.rbKey('entity.orderitem.quantity')#</th>
		</tr>
		<cfloop array="#rc.Order.getOrderItems()#" index="local.orderItem">
			<tr>
				<td>#local.orderItem.getSku().getProduct().getBrand().getBrandName()#</td>
				<td class="varWidth">#local.orderItem.getSku().getProduct().getProductName()#</td>
				<td>#local.orderItem.getSku().displayOptions()#</td>
				<td>#local.orderItem.getSku().getSkuCode()#</td>
				<td>#local.orderItem.getQuantity()#</td>
			</tr>
		</cfloop>
	</table>
	</div>
</div>
</cfoutput>
