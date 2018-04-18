using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {

    public Transform target;

    Vector3 rotationOffset;
    float rotationSpeed = 1f;
    Vector3 positionOffset;
    float followSpeed = 15f;
    bool allowedToMove = true;
    float wakeUpDistance = 1f;
    float forwardOffset = 2f;

    Vector3 previousTargetForward;
    Vector3 currentPositionOffset;
    public float transitionSpeed = 1f;

    void Start()
    {
        positionOffset = transform.position - target.position;
        rotationOffset = transform.eulerAngles;
        previousTargetForward = target.forward;
    }


    void LateUpdate()
    {
        float t = Time.deltaTime;

        Vector3 targetPos = target.position;

        Vector3 currentTargetForward = Vector3.Lerp(previousTargetForward, target.forward, .3f * t);

        currentPositionOffset = Vector3.Lerp(currentPositionOffset, positionOffset, transitionSpeed * t);

        Vector3 nextPosition = targetPos + currentPositionOffset + currentTargetForward * forwardOffset;

        transform.position = Vector3.Lerp(transform.position, nextPosition, followSpeed * t);


        Vector3 nextRotation = transform.eulerAngles;
        nextRotation.x = Mathf.LerpAngle(nextRotation.x, rotationOffset.x, rotationSpeed * t);
        nextRotation.y = Mathf.LerpAngle(nextRotation.y, rotationOffset.y, rotationSpeed * t);
        nextRotation.z = Mathf.LerpAngle(nextRotation.z, rotationOffset.z, rotationSpeed * t);
        transform.rotation = Quaternion.Euler(nextRotation);
        
        previousTargetForward = currentTargetForward;
    }


    public void SetOffset(Vector3 newRotOffset, float newRotSpeed, Vector3 newPosOffset, float newFollowingSpeed, float newTransitionSpeed)
    {
        rotationOffset = newRotOffset;
        rotationSpeed = newRotSpeed;
        positionOffset = newPosOffset;
        followSpeed = newFollowingSpeed;
        transitionSpeed = newTransitionSpeed;
    }


    public void JumpCut(Vector3 newPosition)
    {
        transform.position = newPosition + target.position + previousTargetForward * forwardOffset;
        currentPositionOffset = newPosition;
        Debug.Log("JUMP CUT TO : " + transform.position);
        transform.rotation = Quaternion.Euler(rotationOffset);
    }
}
