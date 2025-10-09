trigger OpportunityTrigger on Opportunity (before update, before delete, after update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHelper.afterUpdate(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isDelete) {
        OpportubityTriggerHelper.beforeDelete(Trigger.old);
    }
}