using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class BossEnemy : MonoBehaviour {

    public Transform Target;
    public GameObject Bullet;
    public float MoveSpeed = 4.0f;
    public float MaxDist = 10.0f;
    public float MinDist = 5.0f;
    public float FireRate = 10.0f;
    public float WakeUpDistance = 5.0f;
    public int Damage = 5;  

    
    
    private float cooldownTime = 0.0f;


    void Update()
    {
        transform.LookAt(Target);

        if(Vector3.Distance(transform.position,Target.position) >= MinDist)
        {
            transform.position += transform.forward * MoveSpeed * Time.deltaTime;
            if(Vector3.Distance(transform.position,Target.position) <= MaxDist)
            {
               
            }
        }
    }
}
