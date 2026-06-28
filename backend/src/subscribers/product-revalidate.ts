import { SubscriberArgs, type SubscriberConfig } from "@medusajs/framework"

export default async function productRevalidateSubscriber({
  event: { name },
}: SubscriberArgs<{ id: string }>) {
  const storeUrl = process.env.STOREFRONT_URL
  const secret = process.env.REVALIDATE_SECRET

  if (storeUrl && secret) {
    try {
      console.log(`[Storefront Sync] Revalidating products due to event: ${name}`)
      await fetch(`${storeUrl}/api/revalidate?secret=${secret}&tag=products`, {
        method: "POST",
      })
      console.log(`[Storefront Sync] Revalidated successfully`)
    } catch (e) {
      console.error(`[Storefront Sync] Failed to revalidate:`, e)
    }
  } else {
    console.warn(`[Storefront Sync] STOREFRONT_URL or REVALIDATE_SECRET is missing.`)
  }
}

export const config: SubscriberConfig = {
  event: [
    "product.created",
    "product.updated",
    "product.deleted"
  ],
}
