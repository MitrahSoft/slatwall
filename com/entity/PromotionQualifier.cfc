/*

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

*/
component displayname="Promotion Qualifier" entityname="SlatwallPromotionQualifier" table="SlatwallPromotionQualifier" persistent="true" extends="BaseEntity" discriminatorColumn="qualifierType" {
	
	// Persistent Properties
	property name="promotionQualifierID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minimumQuantity" ormtype="integer" hint="can apply to product, order,or shipping qualifiers";
	property name="minimumPrice" ormtype="big_decimal";
	property name="maximumPrice" ormtype="big_decimal"; 
	
	// Related Entities
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	
	// Special Related Discriminator Property
	property name="qualifierType" length="255" insert="false" update="false";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	// Non-persistent entities
	property name="discountType" persistent="false";
	property name="qualifierTypeDisplay" type="string" persistent="false";
	property name="qualifierItems" type="string" persistent="false";
	
	// ============ Association management methods for bidirectional relationships =================
	
	// Promotion Period (many-to-one)
	
	public void function setPromotionPeriod(required PromotionPeriod promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(isNew() || !arguments.promotionPeriod.hasPromotionQualifier(this)) {
			arrayAppend(arguments.promotionPeriod.getPromotionQualifiers(),this);
		}
	}
	
	public void function removePromotionPeriod(PromotionPeriod promotionPeriod) {
	   if(!structKeyExists(arguments,"promotionPeriod")) {
	   		arguments.promotionPeriod = variables.promotionPeriod;
	   }
       var index = arrayFind(arguments.promotionPeriod.getPromotionQualifiers(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotionPeriod.getPromotionQualifiers(), index);
       }
       structDelete(variables,"promotionPeriod");
    }
    
    // ============   END Association Management Methods   =================

	public string function getSimpleRepresentation() {
		return getPromotionPeriod().getPromotion().getPromotionName();
	}

	// ============ START: Non-Persistent Property Methods =================

	
	public string function getQualifierTypeDisplay() {
		return rbKey( "entity.promotionQualifier.qualifierType." & getQualifierType() );
	}
	
	public string function getQualifierItems() {
		if( !structKeyExists( variables,"qualifierItems" ) ) {
			variables.qualifierItems = "";
			if( getQualifierType() eq "product" ) {
				var items = "";
				if( arrayLen(getSkus()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionQualifierProduct.skus') & ": ";
					items &= displaySkuCodes();
					items &= "</p>";
				}
				if( arrayLen(getProducts()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionQualifierProduct.products') & ": ";
					items &= displayProductNames();
					items &= "</p>";
				}
				if( arrayLen(getProductTypes()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionQualifierProduct.productTypes') & ": ";
					items &= displayProductTypeNames();
					items &= "</p>";
				}
				if( arrayLen(getBrands()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionQualifierProduct.brands') & ": ";
					items &= displayBrandNames();
					items &= "</p>";
				}
				if( arrayLen(getOptions()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionQualifierProduct.options') & ": ";
					items &= displayOptionNames();
					items &= "</p>";
				}
				if( len(items) == 0 ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey("define.all");
					items &= "</p>";
				}
			} else if( getQualifierType() == "fulfillment" ) {
				if( arrayLen(getFulfillmentMethods()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionQualifierFulfillment.fulfillmentMethods') & ": ";
					items &= displayFulfillmentMethodNames();
					items &= "</p>";
				}
				if( arrayLen(getShippingMethods()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionQualifierFulfillment.shippingMethods') & ": ";
					items &= displayShippingMethodNames();
					items &= "</p>";
				}
				if( arrayLen(getAddressZones()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionQualifierFulfillment.addressZones') & ": ";
					items &= displayAddressZoneNames();
					items &= "</p>";
				}
				if( len(items) == 0 ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey("define.all");
					items &= "</p>";
				}			
			} else if( getQualifierType() == "order" ) {
				items = $.Slatwall.rbKey("define.na");
			}
			variables.qualifierItems = items;	
		}
		return variables.qualifierItems;
	}
		
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}