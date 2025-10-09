public with sharing class OpportunityTriggerHelper {

    public static void beforeUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap) {
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldMap.get(opp.Id);

            if (opp.Amount != oldOpp.Amount) {
                if (opp.Amount != null && opp.Amount <= 5000) {
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }
        }
    }


    public static void afterUpdate(List<Opportunity> newOpps) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        List<Contact> ceos = [SELECT Id, AccountId
                              FROM Contact
                              WHERE AccountId IN :accountIds AND Title = 'CEO'];
        Map<Id, Contact> ceoMap = new Map<Id, Contact>();
        for (Contact con : ceos) {
            if (!ceoMap.containsKey(con.AccountId)) {
                ceoMap.put(con.AccountId, con);
            }
        }

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Opportunity opp : newOpps) {
            Contact ceo = ceoMap.get(opp.AccountId);
            if (ceo != null) {
                if (opp.Primary_Contact__c != ceo.Id) {
                    Opportunity oppUpdate = new Opportunity();
                    oppUpdate.Id = opp.Id;
                    oppUpdate.Primary_Contact__c = ceo.Id;
                    oppsToUpdate.add(oppUpdate);
                }
            }
        }

        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }

    public static void beforeDelete(List<Opportunity> oldOpps) {
        Set<Id> accountIds = new set<Id>();
        for (Opportunity opp : oldOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Industry
                                                         FROM Account
                                                         WHERE Id IN :accountIds]);
        for (Opportunity opp : oldOpps) {
            Account acc = accounts.get(opp.AccountId);
            if (opp.StageName == 'Closed Won' && acc != null && acc.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
        
}