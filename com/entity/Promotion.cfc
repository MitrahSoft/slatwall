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
component displayname="Promotion" entityname="SlatwallPromotion" table="SlatwallPromotion" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="promotionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="promotionName" ormtype="string";
	property name="promotionSummary" ormtype="string" length="1000";
	property name="promotionDescription" ormtype="string" length="4000";
	property name="activeFlag" ormtype="boolean" default="1";
	
	// Related Object Properties (many-to-one)
	property name="defaultImage" cfc="PromotionImage" fieldtype="many-to-one" fkcolumn="defaultImageID";
	
	// Related Object Properties (one-to-many)
	property name="promotionPeriods" singularname="promotionPeriod" cfc="PromotionPeriod" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all-delete-orphan" inverse="true";    
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all-delete-orphan" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-persistent properties
	property name="startDateTime" type="date" persistent="false";
	property name="endDateTime" type="date" persistent="false"; 
	
	public Promotion function init(){
		// set default collections for association management methods
		if(isNull(variables.promotionCodes)){
		   variables.promotionCodes = [];
		}
		
		if(isNull(variables.promotionPeriods)) {
			variables.promotionPeriods = [];
		}
		return super.init();
	}
 

	/******* Association management methods for bidirectional relationships **************/

	// promotionPeriods (one-to-many)
	public void function addPromotionPeriod(required any PromotionPeriod) {
		arguments.PromotionPeriod.setPromotion( this );
	}
	public void function removePromotionPeriod(required any PromotionPeriod) {
		arguments.PromotionPeriod.removePromotion( this );
	}
	
	// promotionCodes (one-to-many)
	public void function addPromotionCode(required any promotionCode) {
		arguments.promotionCode.setPromotion(this);
	}
	
	public void function removePromotionCode(required any promotionCode) {
	   arguments.promotionCode.removePromotion(this);
	}
	
	// appliedPromotions (one-to-many)
	public void function addAppliedPromotion(required any promotionApplied) {
	   arguments.promotionApplied.setPromotion(this);
	}
	
	public void function removeAppliedPromotion(required any promotionApplied) {
		arguments.promotionApplied.removePromotion(this);
	}
	
    /************   END Association Management Methods   *******************/

	// @hint this method validates that promotion codes are unique
	public any function hasUniquePromotionCodes() {
		var promotionCodeList = "";
		
		for(var promotionCode in getPromotionCodes()){
			if(listFindNoCase(promotionCodeList, promotionCode.getPromotionCode())) {
				return false;
			} else {
				promotionCodeList = listAppend(promotionCodeList, promotionCode.getPromotionCode());
			}
		}
		return true;
	}

	// ============ START: Non-Persistent Property Methods =================
	
	// gets the start and end DateTimes for the current or the most recent promotion period
	public any function getStartDateTime() {
		if( !structKeyExists( variables,"startDateTime" ) ) {
			for( var i=1; i<=arrayLen(getPromotionPeriods());i++ ) {
				local.thisPromotionPeriod = getPromotionPeriods()[i];
				if( local.thisPromotionPeriod.isCurrent() ) {
					variables.startDateTime = local.thisPromotionPeriod.getStartDateTime();
					variables.endDateTime = local.thisPromotionPeriod.getEndDateTime();
					break;
				}
				else {
					variables.startDateTime = !structKeyExists(variables,"startDateTime") ? local.thisPromotionPeriod.getStartDateTime() : local.thisPromotionPeriod.getEndDateTime() > variables.endDateTime ? local.thisPromotionPeriod.getStartDateTime() : variables.startDateTime;
					variables.endDateTime = !structKeyExists(variables,"endDateTime") ? local.thisPromotionPeriod.getEndDateTime() : local.thisPromotionPeriod.getEndDateTime() > variables.endDateTime ? local.thisPromotionPeriod.getEndDateTime() : variables.endDateTime;
				}
			}
		}
		return variables.startDateTime;
	}
	
	public any function getEndDateTime() {
		if( !structKeyExists( variables,"endDateTime" ) ) {
			for( var i=1; i<=arrayLen(getPromotionPeriods());i++ ) {
				local.thisPromotionPeriod = getPromotionPeriods()[i];
				if( local.thisPromotionPeriod.isCurrent() ) {
					variables.startDateTime = local.thisPromotionPeriod.getStartDateTime();
					variables.endDateTime = local.thisPromotionPeriod.getEndDateTime();
					break;
				}
				else {
					variables.startDateTime = !structKeyExists(variables,"startDateTime") ? local.thisPromotionPeriod.getStartDateTime() : local.thisPromotionPeriod.getEndDateTime() > variables.endDateTime ? local.thisPromotionPeriod.getStartDateTime() : variables.startDateTime;
					variables.endDateTime = !structKeyExists(variables,"endDateTime") ? local.thisPromotionPeriod.getEndDateTime() : local.thisPromotionPeriod.getEndDateTime() > variables.endDateTime ? local.thisPromotionPeriod.getEndDateTime() : variables.endDateTime;
				}
			}
		}
		return variables.endDateTime;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("skuCacheService").updateFromPromotion( this );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromPromotion( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	
}