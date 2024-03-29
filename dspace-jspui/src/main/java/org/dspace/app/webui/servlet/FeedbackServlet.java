/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.apache.commons.validator.EmailValidator;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.Email;
import org.dspace.core.I18nUtil;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.json.JSONObject;

/**
 * Servlet for handling user feedback
 *
 * @author Peter Breton
 * @author Robert Tansley
 * @version $Revision$
 */
public class FeedbackServlet extends DSpaceServlet
{
    /** log4j category */
    private static Logger log = Logger.getLogger(FeedbackServlet.class);

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {

        // Obtain information from request
        // The page where the user came from
        String fromPage = request.getHeader("Referer");

        // Prevent spammers and splogbots from poisoning the feedback page
        String host = ConfigurationManager.getProperty("dspace.hostname");

        String basicHost = "";
        if (host.equals("localhost") || host.equals("127.0.0.1")
        		|| host.equals(InetAddress.getLocalHost().getHostAddress()))
        {
            basicHost = host;
        }
        else
        {
            // cut off all but the hostname, to cover cases where more than one URL
            // arrives at the installation; e.g. presence or absence of "www"
            int lastDot = host.lastIndexOf('.');
            basicHost = host.substring(host.substring(0, lastDot).lastIndexOf("."));
        }

        if (fromPage == null || fromPage.indexOf(basicHost) == -1)
        {
            fromPage = "";
        }

        // The email address they provided
        String formEmail = request.getParameter("email");

        // Browser
        String userAgent = request.getHeader("User-Agent");

        // Session id
        String sessionID = request.getSession().getId();

        // User email from context
        EPerson currentUser = context.getCurrentUser();
        String authEmail = null;

        if (currentUser != null)
        {
            authEmail = currentUser.getEmail();
        }

        // Has the user just posted their feedback?
        if (request.getParameter("submita") != null)
        {
            EmailValidator ev = EmailValidator.getInstance();
            String feedback = request.getParameter("feedback");
            String subject = request.getParameter("feedsubject");
            String name = request.getParameter("feedname");

            // Check all data is there
            if ((formEmail == null) || formEmail.equals("")
                    || (feedback == null) || feedback.equals("") || !ev.isValid(formEmail))
            {
                log.info(LogManager.getHeader(context, "show_feedback_form",
                        "problem=true"));
                request.setAttribute("feedback.problem", Boolean.TRUE);
                JSPManager.showJSP(request, response, "/feedback/form.jsp");

                return;
            }

            // All data is there, send the email
            try
            {
                Email email = Email.getEmail(I18nUtil.getEmailFilename(context.getCurrentLocale(), "feedback"));
                email.addRecipient(ConfigurationManager
                        .getProperty("feedback.recipient"));

                email.addArgument(new Date()); // Date
                email.addArgument(formEmail); // Email
                email.addArgument(authEmail); // Logged in as
                email.addArgument(fromPage); // Referring page
                email.addArgument(userAgent); // User agent
                email.addArgument(sessionID); // Session ID
                email.addArgument(feedback); // The feedback itself
                email.addArgument(subject != null ? subject : ""); // The feedback itself
                email.addArgument(name != null ? name : ""); // The feedback itself

                // Replying to feedback will reply to email on form
                email.setReplyTo(formEmail);

                email.send();


                log.info(LogManager.getHeader(context, "sent_feedback", "from="
                        + formEmail));

                JSPManager.showJSP(request, response,
                        "/feedback/acknowledge.jsp");
            }
            catch (MessagingException me)
            {
                log.warn(LogManager.getHeader(context,
                        "error_mailing_feedback", ""), me);

                JSPManager.showInternalError(request, response);
            }
        }
        else
        {
            // Display feedback form
            log.info(LogManager.getHeader(context, "show_feedback_form",
                    "problem=false"));
            request.setAttribute("authenticated.email", authEmail);
            JSPManager.showJSP(request, response, "/feedback/form.jsp");
        }
    }

    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // Treat as a GET
        HttpPost post = new HttpPost("https://www.google.com/recaptcha/api/siteverify");
        List<BasicNameValuePair> params = Arrays.asList(new BasicNameValuePair("secret", "6Ldm7OIgAAAAAFlSXz7S-vfXkQRP4udFNUAWHDYC"), new BasicNameValuePair("response", request.getParameter("captcha-rocks")));

        post.setEntity(new UrlEncodedFormEntity(params));

        try (CloseableHttpClient httpClient = HttpClients.createDefault();
             CloseableHttpResponse reponseHttpClient = httpClient.execute(post)) {

            JSONObject jsonObject = new JSONObject(EntityUtils.toString(reponseHttpClient.getEntity()));
            if(jsonObject.getBoolean("success")) {
                doDSGet(context, request, response);
            }
            else {
                JSPManager.showInternalError(request, response);
            }
        }

    }
}
