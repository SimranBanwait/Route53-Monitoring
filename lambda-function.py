import boto3
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SENDER_EMAIL    = "awsalert.staging@ohiomron.com"
RECIPIENT_EMAIL = "awsalert.staging@ohiomron.com"
AWS_REGION      = "us-east-1"
RUNBOOK_URL     = "https://omronhealthcare-ohi.atlassian.net/wiki/spaces/ODS/pages/3453517825/ODS-Alert-Runbook+Region+-+Environment+-Alert+VLT+Mobile+Downstream+Processing+Error"

route53 = boto3.client("route53")
ses     = boto3.client("ses", region_name=AWS_REGION)


def get_zone_name(zone_id):
    try:
        clean_id = zone_id.split("/")[-1]
        paginator = route53.get_paginator("list_hosted_zones")
        for page in paginator.paginate():
            for zone in page["HostedZones"]:
                if zone["Id"].split("/")[-1] == clean_id:
                    return zone["Name"].rstrip(".")
    except Exception as e:
        logger.warning(f"Could not resolve zone name for {zone_id}: {e}")
    return zone_id


def get_action_word(change_batch):
    changes = change_batch.get("changes", change_batch.get("Changes", []))
    if not changes:
        return "modification"
    action = changes[0].get("action", changes[0].get("Action", "UPSERT")).upper()
    if action == "CREATE":
        return "creation"
    elif action == "DELETE":
        return "deletion"
    else:
        return "modification"


def get_record_name(change_batch):
    changes = change_batch.get("changes", change_batch.get("Changes", []))
    if not changes:
        return "N/A"
    rrs = changes[0].get("resourceRecordSet", changes[0].get("ResourceRecordSet", {}))
    return rrs.get("name", rrs.get("Name", "N/A")).rstrip(".")


def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    detail        = event.get("detail", {})
    req_params    = detail.get("requestParameters", {})
    user_identity = detail.get("userIdentity", {})

    zone_id      = req_params.get("hostedZoneId", "N/A")
    caller       = (
        user_identity.get("userName")
        or user_identity.get("arn")
        or user_identity.get("type")
        or "N/A"
    )
    change_batch  = req_params.get("changeBatch", {})

    zone_name     = get_zone_name(zone_id) if zone_id != "N/A" else "N/A"
    action_word   = get_action_word(change_batch)
    record_name   = get_record_name(change_batch)
    clean_zone_id = zone_id.split("/")[-1] if zone_id != "N/A" else "N/A"

    subject = f"POC-USSTG-Route53-DNS Record {action_word} for domain - {zone_name}"

    body_text = f"""Hi Team,

We have encountered {action_word} of a record {record_name}, in Hosted zone {zone_name} {clean_zone_id} by user {caller}

Please refer to detailed runbook at - {RUNBOOK_URL}

Sincerely,
Connected Health R&D Team

This message is intended for designated recipients only. If you are not the authorized recipient, or you were not expecting this message, or if you have received this message in error, please delete all copies of this message. Any unauthorized use or distribution of this message is prohibited."""

    try:
        ses.send_email(
            Source=SENDER_EMAIL,
            Destination={"ToAddresses": [RECIPIENT_EMAIL]},
            Message={
                "Subject": {"Data": subject, "Charset": "UTF-8"},
                "Body": {
                    "Text": {"Data": body_text, "Charset": "UTF-8"},
                },
            },
        )
        logger.info("Alert email sent successfully.")
    except Exception as e:
        logger.error(f"Failed to send email: {e}")
        raise

    return {"statusCode": 200, "body": "Alert sent."}