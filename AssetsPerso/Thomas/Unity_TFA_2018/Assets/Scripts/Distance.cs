using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Distance : MonoBehaviour
{
    public Transform Target;
    public GameObject Bullet;
    public float FireRate = 10.0f;
    public float WakeUpDistance = 5.0f;

    private float colldownTime = 0.0f;

    void Start()
    {

    }
    
    void Update()
    {
        Vector3 lookPosition = Target.position - transform.position;
        Quaternion rotation = Quaternion.LookRotation(lookPosition);
        float distanceToPlayer = (transform.position - Target.transform.position).magnitude;
        colldownTime -= Time.deltaTime;
        if (distanceToPlayer <= WakeUpDistance)
        {

            if (colldownTime <= 0.0f)
            {
                Instantiate(Bullet, transform.position, rotation);
                colldownTime = 1 / FireRate;
            }
        }

    }
}
