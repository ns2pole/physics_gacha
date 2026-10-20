import * as admin from "firebase-admin";
import {HttpError} from "./http";

export async function deleteFirebaseUserAccount(
  db: FirebaseFirestore.Firestore,
  uid: string,
): Promise<void> {
  if (uid.length === 0) {
    throw new HttpError(400, "invalid_uid", "User ID is required.");
  }

  const userRef = db.collection("users").doc(uid);
  await db.recursiveDelete(userRef);

  try {
    await admin.auth().deleteUser(uid);
  } catch (error) {
    if (isAuthUserNotFoundError(error)) {
      return;
    }
    throw error;
  }
}

function isAuthUserNotFoundError(error: unknown): boolean {
  return (
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    (error as {code?: unknown}).code === "auth/user-not-found"
  );
}
