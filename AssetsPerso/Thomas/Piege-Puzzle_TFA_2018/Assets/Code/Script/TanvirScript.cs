using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TanvirScript : MonoBehaviour 
{
	public float Force;
	public float CoolDown;
	public KeyCode ActivePower;
	public static bool HaveTrigger = false;
	public float PowerDuration = 3.0f;
	public GameObject Forcefield;
	
	private Rigidbody rbCol;
	private bool impulse = false;
	private BoxCollider colTanvir;
	private Vector3 difPToOb;
	private Vector3 dir;

	private float coolDownPriv;
	private bool canGrow = true;
	private float timer = 0.0f;
	private bool keyup = false;

	private bool canDissovle = false;
	private Renderer rend;
	private Material material;
	private float t;

	void Start () 
	{
		colTanvir = GetComponent<BoxCollider>();
		rend = Forcefield.GetComponent<Renderer>();
		material = rend.material;
		coolDownPriv = CoolDown;
	}
	
	
	void Update () 
	{
		CoolDown -= Time.deltaTime;
		if(Input.GetKey(ActivePower) && CoolDown <= 0.0f && canGrow)
		{	
			Player.Current.MoveSpeed = 2.0f;
			if(canGrow)
			{
				colTanvir.size += new Vector3(0.1f,0.1f,0.1f);
				Forcefield.transform.localScale += new Vector3(0.1f,0.1f,0.1f);
			}
				
			if(Forcefield.transform.localScale.x >=10.0f && Forcefield.transform.localScale.y >=10.0f && Forcefield.transform.localScale.z >=10.0f)
			{
				canGrow = false;
				CoolDown = coolDownPriv;
			}
			else
				canGrow = true;
		}
		if(Input.GetKeyUp(ActivePower) || (Forcefield.transform.localScale.x >=10.0f && Forcefield.transform.localScale.y >=10.0f && Forcefield.transform.localScale.z >=10.0f))
		{
			impulse = true;
			canGrow = false;
			Player.Current.MoveSpeed = 12.0f;
			keyup = true;	
		}
		if(keyup || (Forcefield.transform.localScale.x >=10.0f && Forcefield.transform.localScale.y >=10.0f && Forcefield.transform.localScale.z >=10.0f))
		{
			timer += Time.deltaTime;
			if(timer >= PowerDuration)
			{
				canDissovle = true;
				impulse = false;
				timer = 0.0f;
				keyup = false;
			}
		}
		if(canDissovle)
		{
			t +=Time.deltaTime;
			colTanvir.size = new Vector3(1.0f,1.0f,1.0f);
			material.SetFloat("_DissolveAmount",Mathf.Lerp(0.0f,1.0f,t*0.5f));
		}
				
		if(material.GetFloat("_DissolveAmount") >= 1.0f)
		{
			canDissovle = false;
			t = 0.0f;
			Forcefield.transform.localScale = new Vector3(1.0f,1.0f,1.0f);
			Debug.Log("Get Float Up to 1.0f");
			canGrow = true;
			material.SetFloat("_DissolveAmount",0.0f);
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
