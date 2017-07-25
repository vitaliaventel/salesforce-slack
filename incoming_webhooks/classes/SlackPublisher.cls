public class SlackPublisher {

    private static final String SLACK_URL = 'https://hooks.slack.com/services/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';

    public class Oppty {

        @InvocableVariable(label='Opportunity Name')
        public String opportunityName;
        @InvocableVariable(label='Stage')
        public String stage;

    }

    @InvocableMethod(label='Post to Slack(Opportunity)')
    public static void postToSlack(List<Oppty> oppties) {
        Oppty opp = oppties[0];
        Map<String, Object> msg = new Map<String, Object>();
        msg.put('text', 'The following opportunity has changed!!! \n' + opp.opportunityName);
        msg.put('mrkdwn', true);
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