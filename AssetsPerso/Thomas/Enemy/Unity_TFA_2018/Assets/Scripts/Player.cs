using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public static float Speed = 7.0f;
    public float RotateSpeed = 10.0f;
    public GameObject Bullet;
    public float FireRate = 10.0f;

    private float distanceCooldownTime = 0.0f;
    
	public GameObject MeleeWeaponRef;
	public float AttackRate = 10.0f;

	private Transform meleeWeaponSpawn;
	private Vector3 offset = new Vector3(1.5f, 0.0f, 0.0f);

	private float meleeCoolDownTime = 0.0f;
	private Quaternion rotationMeleeWeapon;
	
    private static Player current;
	public static Player Current
	{
		get { return current; }
	}
    void Awake()
	{
		current = this;
		meleeWeaponSpawn = transform.Find("MeleeSpawner");
	}

    void Update()
    {

        float x = Input.GetAxis("Horizontal") * Time.deltaTime * RotateSpeed;
        float z = Input.GetAxis("Vertical") * Time.deltaTime * Speed;

        float horizontalFire = Input.GetAxis ("Horizontal2");
		float verticalFire = Input.GetAxis ("Vertical2");

        float intensity = Mathf.Sqrt(horizontalFire * horizontalFire + verticalFire * verticalFire);

        transform.Rotate(0.0f,x,0.0f);
        transform.Translate(0.0f,0.0f,z);
	    distanceCooldownTime -= Time.deltaTime;

        if(intensity >0.5f)
        {
            Quaternion rotationFire = Quaternion.LookRotation (new Vector3 (horizontalFire, 0.0f, verticalFire));
            if (distanceCooldownTime <= 0.0f)
            {
                Instantiate(Bullet, transform.localPosition, rotationFire);
	            distanceCooldownTime = 1.0f / FireRate;
            }
        }
	    
	    rotationMeleeWeapon = Quaternion.LookRotation(new Vector3(0.0f, 90.0f, 0.0f));
	    meleeCoolDownTime -= Time.deltaTime;
	    if (Input.GetKeyDown(KeyCode.A) && meleeCoolDownTime <= 0.0f)
	    {
		    Instantiate(MeleeWeaponRef, meleeWeaponSpawn.position + offset, rotationMeleeWeapon);
		    meleeCoolDownTime = 1.0f / AttackRate;
	    }
    }
}
