import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import * as OneSignal from 'https://esm.sh/@onesignal/node-onesignal@1.0.0-beta7'

const _OnesignalAppId_ = Deno.env.get('ONESIGNAL_APP_ID')!
const _OnesignalUserAuthKey_ = Deno.env.get('USER_AUTH_KEY')!
const _OnesignalRestApiKey_ = Deno.env.get('ONESIGNAL_REST_API_KEY')!
const configuration = OneSignal.createConfiguration({
  userKey: _OnesignalUserAuthKey_,
  appKey: _OnesignalRestApiKey_,
})

const onesignal = new OneSignal.DefaultApi(configuration)

serve(async (req) => {
  try {
    const { record } = await req.json()

    // Build OneSignal notification object
    const notification = new OneSignal.Notification()
    notification.app_id = _OnesignalAppId_
    const users = record.target_users_id.split(',')
    notification.include_external_user_ids = users
    notification.headings = {
      en: record.title
    }
    notification.contents = {
      en: record.content,
    }
    const idChat = record.id_chat
    notification.app_url=`https://lspqgm0n-51502.asse.devtunnels.ms/chat?id_chat=${id_chat}&name=${record.title}&avatar=`
    const onesignalApiRes = await onesignal.createNotification(notification)

    console.log('Sent notification successfully');
    return new Response(
      JSON.stringify({ onesignalResponse: onesignalApiRes }),
      {
        headers: { 'Content-Type': 'application/json' },
      }
    )
  } catch (err) {
    console.error('Failed to create OneSignal notification', err)
    return new Response('Server error.', {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
