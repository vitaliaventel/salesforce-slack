/**
 * Created by Vitalii Leshchenko on 21.07.2017.
 */

public with sharing class AccountCreateSlack {

    private static final String SLACK_URL = 'YOUR_URL_CHANGE_IT';

    public class Acc {

        @InvocableVariable(label='Name')
        public String accountName;

    }

    @InvocableMethod(label='Post to Slack(Account)')
    public static void postToSlack(List<Acc> accs) {
        Acc a = accs[0];
        Map<String, Object> msg = new Map<String, Object>();
        if(accs.size() == 1){
            msg.put('text', 'The following account has created: \n' + a.accountName);
            msg.put('mrkdwn', true);
        }else{
            msg.put('text', 'The following accounts has created: \n' + 'Total size: ' + accs.size() + '\n One of them: ' + a.accountName);
            msg.put('mrkdwn', true);
        }
        String body = JSON.serialize(msg);
        System.enqueueJob(new QueueableSlackCall(SLACK_URL, 'POST', body));
    }

    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
        private final String url;
        private final String method;
        private final String body;

        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }

        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            http.send(req);
        }
    }

}