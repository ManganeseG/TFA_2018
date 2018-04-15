using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TanvirScript : MonoBehaviour 
{
	public float Force;
	//public float CoolDown;
	public KeyCode ActivePower;
	public static bool HaveTrigger = false;
	public float PowerDuration = 3.0f;
	public GameObject Forcefield;
	
	private Rigidbody rbCol;
	private bool impulse = false;
	private BoxCollider colTanvir;
	private Vector3 difPToOb;
	private Vector3 dir;
	//private float coolDownPriv;
	private bool canGrow = true;
	private float timer = 0.0f;
	private bool keyup = false;

	void Start () 
	{
		colTanvir = GetComponent<BoxCollider>();
		//coolDownPriv = CoolDown;
	}
	
	
	void Update () 
	{
		//CoolDown -= Time.deltaTime;
		if(Input.GetKey(ActivePower))
		{	
			Move.speedForScript = 2.0f;
			//CoolDown = coolDownPriv;
			if(canGrow)
			{
				colTanvir.size += new Vector3(0.1f,0.1f,0.1f);
				Forcefield.transform.localScale += new Vector3(0.1f,0.1f,0.1f);
			}
				
			if(Forcefield.transform.localScale.x >=10.0f && Forcefield.transform.localScale.y >=10.0f && Forcefield.transform.localScale.z >=10.0f)
				canGrow = false;
			else
				canGrow = true;
		}
		if(Input.GetKeyUp(ActivePower))
		{
			impulse = true;
			Move.speedForScript = 12.0f;
			keyup = true;	
		}
		if(keyup)
		{
			timer += Time.deltaTime;
			if(timer >= PowerDuration)
			{
				impulse = false;
				timer = 0.0f;
				colTanvir.size = new Vector3(1.0f,1.0f,1.0f);
				Forcefield.transform.localScale = new Vector3(1.0f,1.0f,1.0f);
				keyup = false;
			}
		}
	}

	void OnTriggerStay (Collider col)
	{
		rbCol = col.GetComponent<Rigidbody>();

		if( rbCol != null)
		{
			difPToOb = transform.position - col.transform.position;

			float dist = difPToOb.magnitude;
			dir	= difPToOb/dist;

			if(HaveTrigger && PuzzleTanvir.OneOk && PuzzleTanvir.SecOk)
			{
				rbCol.isKinematic = true;
				return;
			}

			if(impulse)
			{
				rbCol.AddForce(-dir * Force,ForceMode.Impulse);
			}
		}
	}
	void OnTriggerExit(Collider col)
	{
		rbCol = col.GetComponent<Rigidbody>();

		if( rbCol != null)
		{
			difPToOb = transform.position - col.transform.position;

			float dist = difPToOb.magnitude;
			dir	= difPToOb/dist;
			rbCol.velocity = rbCol.velocity * 0.8f;
		}
	}
}
