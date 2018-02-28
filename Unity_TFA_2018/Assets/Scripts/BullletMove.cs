using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BullletMove : MonoBehaviour
{

    public float BulletSpeed = 15f;
    public float DistanceBeforeDeath = 25.0f;

    private float DistanceDone;

    void Update()
    {
        transform.Translate(Vector3.forward * Time.deltaTime * BulletSpeed);
        DistanceDone += Time.deltaTime * BulletSpeed;

        if (DistanceDone > DistanceBeforeDeath)
        {
            Destroy(gameObject);
        }

    }
}
