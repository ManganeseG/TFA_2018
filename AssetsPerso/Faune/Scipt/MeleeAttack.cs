using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeleeAttack : MonoBehaviour
{
    public GameObject MeleeWeaponRef;
    public float AttackRate = 10.0f;

    private Transform meleeWeaponSpawn;
    private Vector3 offset = new Vector3(1.5f, 0.0f, 0.0f);

    private float coolDownTime = 0.0f;
    private Quaternion rotationMeleeWeapon;

    void Start()
    {
        meleeWeaponSpawn = transform.Find("MeleeSpawner");
    }

    
    void Update()
    {
        rotationMeleeWeapon = Quaternion.LookRotation(new Vector3(0.0f, 90.0f, 0.0f));
        coolDownTime -= Time.deltaTime;
        
        if (Input.GetKeyDown(KeyCode.A) && coolDownTime <= 0.0f)
        {
            Instantiate(MeleeWeaponRef, meleeWeaponSpawn.position + offset, rotationMeleeWeapon);
            coolDownTime = 1.0f / AttackRate;
        }
    }
}