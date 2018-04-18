using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControl : MonoBehaviour {

    public Vector3 rotation;
    public Vector3 position;
    [Range(0f, 1f)]
    public float rotationSpeed = 0.5f;
    public float followingSpeed = 0.5f;

    void OnTriggerEnter(Collider col)
    {
        Camera.main.GetComponent<CameraFollow>().SetOffset(rotation, rotationSpeed, position, followingSpeed);
    }

    void OnTriggerStay(Collider col)
    {
        Camera.main.GetComponent<CameraFollow>().SetOffset(rotation, rotationSpeed, position, followingSpeed);
    }
}
