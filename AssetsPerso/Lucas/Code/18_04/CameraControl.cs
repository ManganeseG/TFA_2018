using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControl : MonoBehaviour {

    public Vector3 position;
    public Vector3 rotation;
    public float rotationSpeed = 0.5f;
    public float followingSpeed = 0.5f;
    public float transitionSpeed = 0.5f;

    //[Header("JUMP CUT")]
    public bool jumpCutDesired;
    public CameraControl twin;
    //public Vector3 jumpCutPosition;
    //public Vector3 jumpCutRotation;
    int direction = 1;
    bool allowedToModifyCamera = true;

    void OnTriggerEnter(Collider col)
    {
        if(allowedToModifyCamera)
            Camera.main.GetComponent<CameraFollow>().SetOffset(rotation, rotationSpeed, position, followingSpeed, transitionSpeed);

        if(jumpCutDesired)
        {
            twin.jumpCutDesired = true;
            jumpCutDesired = false;
            Camera.main.GetComponent<CameraFollow>().JumpCut(position);
        }
    }

    
    void OnTriggerStay(Collider col)
    {
        if(allowedToModifyCamera)
            Camera.main.GetComponent<CameraFollow>().SetOffset(rotation, rotationSpeed, position, followingSpeed, transitionSpeed);
    }
    
}
