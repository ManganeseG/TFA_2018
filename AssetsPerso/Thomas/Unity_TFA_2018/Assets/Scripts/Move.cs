using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{
    public float Speed = 10f;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Z))
            transform.position = transform.position + Vector3.forward * Time.deltaTime * Speed;
        if (Input.GetKey(KeyCode.Q))
            transform.position = transform.position + Vector3.left * Time.deltaTime * Speed;
        if (Input.GetKey(KeyCode.D))
            transform.position = transform.position + Vector3.right * Time.deltaTime * Speed;
        if (Input.GetKey(KeyCode.S))
            transform.position = transform.position + Vector3.back * Time.deltaTime * Speed;

    }
}
