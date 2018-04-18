using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GolemExplode : MonoBehaviour {

	public float force;
	public float radius;

	private Rigidbody rigidbody;
	private bool ok = true;

	void Start () 
	{
		rigidbody = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(ok)
		{
			rigidbody.AddExplosionForce(force,transform.position,radius);
			ok = false;
		}
	}
}
