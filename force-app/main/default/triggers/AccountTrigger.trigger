
trigger AccountTrigger on Account (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHelper.beforeInsert(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHelper.afterInsert(Trigger.new);
    }
}