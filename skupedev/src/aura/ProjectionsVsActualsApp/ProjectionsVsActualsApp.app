<aura:application extends="force:slds" implements="force:appHostable,flexipage:availableForAllPageTypes,flexipage:availableForRecordHome,force:hasRecordId" access="global">
    
    <ltng:require styles="{!$Resource.SLDS +'/assets/styles/salesforce-lightning-design-system-ltng.css'}"/>
    
    <aura:handler event="aura:waiting" action="{!c.showSpinner}"/>
    <aura:handler event="aura:doneWaiting" action="{!c.hideSpinner}"/>
    <aura:attribute name="Spinner" type="boolean" default="false"/>
    
    <!--spinner start- -->
    <aura:if isTrue="{!v.Spinner}">
        <div class="SLDS">
        <div aura:id="spinnerId" class="slds-spinner_container">
            <div class="slds-spinner--brand  slds-spinner slds-spinner--medium slds-is-relative" role="alert">
                <span class="slds-assistive-text">Loading</span>
                <div class="slds-spinner__dot-a"></div>
                <div class="slds-spinner__dot-b"></div>
            </div>
        </div>
        </div>
    </aura:if>
    <!--spinner end- -->
    
    <!--page header start- -->
    <div class="SLDS">
        <div class="slds-page-header" style = "background-color : #ffffff">
            <p class="slds-page-header__title slds-truncate" title="">Projections Vs Actuals</p>
            <!-- <span class="slds-badge">Selected Contact:</span>  -->
        </div>
    </div> 
    <!--page header end- -->
    
    <c:FilterComp />    
    
    <c:ProjectionsVsActualsComp />
    
</aura:application>