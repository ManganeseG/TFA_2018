using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {

    public Transform target;
    public float heightDifferenceMax = 5f;

    Vector3 rotationOffset;
    float rotationSpeed = 1f;
    Vector3 positionOffset;
    float followSpeed = 10f;
    bool allowedToMove = true;
    float wakeUpDistance = 1f;
    float forwardOffset = 1.5f;

    float t;

    Vector3 previousTargetPos;


    void Start()
    {
        t = Time.deltaTime;
        positionOffset = transform.position - target.position;
        rotationOffset = transform.eulerAngles;
    }


    void LateUpdate()
    {
        Vector3 targetPos = target.position;
        targetPos.y = 0f;
        Vector3 nextPosition = targetPos + positionOffset + target.forward * forwardOffset;
        
        /*
        if (Vector3.Distance(transform.position, nextPosition) < securityDistance)
            transform.position = Vector3.Lerp(transform.position, nextPosition, followingSpeed * t);
        else
            transform.position = Vector3.Lerp(transform.position, nextPosition, followingSpeed * t);
            */

        transform.position = Vector3.Lerp(transform.position, nextPosition, followSpeed * t);

        Vector3 nextRotation = Vector3.Lerp(transform.eulerAngles, rotationOffset, rotationSpeed * t);
        transform.rotation = Quaternion.Euler(nextRotation);

        previousTargetPos = targetPos;
    }


    public void SetOffset(Vector3 newRotOffset, float newRotSpeed, Vector3 newPosOffset, float newFollowingSpeed)
    {
        rotationOffset = newRotOffset;
        rotationSpeed = newRotSpeed;
        positionOffset = newPosOffset;
        followSpeed = newFollowingSpeed;
    }
}
