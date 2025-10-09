public with sharing class AccountTriggerHelper {
    
public static void beforeInsert(List<Account> newAccounts) {

    Map<String, String> shippingToBilling = new Map<String, String>{
        'BillingStreet' => 'ShippingStreet',
        'BillingCity' => 'ShippingCity',
        'BillingState' => 'ShippingState',
        'BillingPostalCode' => 'ShippingPostalCode',
        'BillingCountry' => 'ShippingCountry'
    };

    for (Account acc : newAccounts) {
        if (String.isBlank(acc.Type)) {
            acc.Type = 'Prospect';
        }

        for (String billingField : shippingToBilling.keySet()) {
            String shippingField = shippingToBilling.get(billingField);
            if (!String.isBlank((String) acc.get(ShippingField))) {
                acc.put(billingField, acc.get(shippingField));
            }
        }

        if (!String.isBlank(acc.Phone) &&
            !String.isBlank(acc.Website) &&
            !String.isBlank(acc.Fax)) {
            acc.Rating = 'Hot';
            }
        }
    }

    public static void afterInsert(List<Account> newAccounts) {
        List<Contact> contactsToInsert = new List<Contact>();

        for (Account acc : newAccounts) {
            contactsToInsert.add(new Contact(
                LastName = 'DefaultContact',
                Email = 'default@email.com',
                AccountId = acc.Id
            ));
        }

        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}