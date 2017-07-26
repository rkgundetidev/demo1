<aura:application >
	<ltng:require styles="{!$Resource.SLDS +'/assets/styles/salesforce-lightning-design-system-ltng.css'}"/>
	<div class="SLDS">
        <div class="demo-only slds-grid" style="height:100%;max-width:100%;background:#f4f6f9;padding:1rem;padding-bottom: 5px;">
            <div class="slds-panel slds-grid slds-grid_vertical slds-nowrap">
                <div class="slds-form slds-form_stacked slds-grow slds-scrollable_y">
					SKUPE – Productivity
				</div>
			</div>
		</div>
	</div>
    <c:FilterComp />
	<c:ProductivityComp />
</aura:application>