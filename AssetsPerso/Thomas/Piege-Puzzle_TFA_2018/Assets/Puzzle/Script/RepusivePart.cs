using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RepusivePart : MonoBehaviour 
{
	public float Force;
	public float IntervalBetweenWave = 5.0f;

	private Rigidbody rbCol;
	private Vector3 difPToOb;
	private Vector3 dir;
	private float intervalTemp;

	void Start()
	{
		intervalTemp = IntervalBetweenWave;
	}
	

	void Update()
	{
		IntervalBetweenWave -= Time.deltaTime;
		if(IntervalBetweenWave <= 0.0f)
		{
			if(transform.localScale.x <=10.0f && transform.localScale.y <=10.0f && transform.localScale.z <=10.0f)
			{
				GrowOneTime();
			}
			else
			{
				IntervalBetweenWave = intervalTemp;	
				transform.localScale = new Vector3(1.0f,1.0f,1.0f);			
			}		
		}
	}

	void GrowOneTime()
	{
		transform.localScale += new Vector3(0.1f,0.1f,0.1f);
	}

	void OnTriggerStay(Collider col)
	{
		rbCol = col.gameObject.GetComponent<Rigidbody>();
		if(rbCol != null)
		{
			if(col.tag == "PuzzleElement")
			{
				difPToOb = transform.position - col.transform.position;

				float dist = difPToOb.magnitude;
				dir	= difPToOb/dist;

				rbCol.AddForce(-dir * Force,ForceMode.Impulse);
			}
		}
	}
}
