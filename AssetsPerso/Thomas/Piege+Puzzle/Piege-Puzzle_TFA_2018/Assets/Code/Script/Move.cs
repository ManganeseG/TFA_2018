using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour 
{

	public float speed  = 5.0f;
	private Rigidbody rb;
	private Vector3 movement;

	void Start () 
	{
		rb = GetComponent<Rigidbody>();
	}
	
	void Update()
	{
		float moveHorizontal = Input.GetAxis ("Horizontal");
        float moveVertical = Input.GetAxis ("Vertical");

        movement = new Vector3 (moveHorizontal, 0.0f, moveVertical);
	}
	
	
	void FixedUpdate () 
	{
        rb.MovePosition(transform.position + movement * speed * Time.deltaTime);
	}


}
